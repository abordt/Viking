﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using AnnotationUtils.AnnotationService;

namespace AnnotationUtils
{
    public static class Queries
    {
        public static SortedDictionary<long, StructureType> IDToStructureType
        {
            get
            {
                if (_IDToStructureType == null)
                    _IDToStructureType = Queries.GetStructureTypes();

                return _IDToStructureType; 
            }
        }

        private static SortedDictionary<long, StructureType> _IDToStructureType = null;

        public static SortedList<string, List<Structure>> LabelToStructuresMap()
        {
            using (AnnotationService.AnnotateStructureTypesClient client = ConnectionFactory.CreateStructureTypesClient())
            {
                return LabelToStructuresMap(client);
            }
        }

        public  static SortedList<string, List<Structure>> LabelToStructuresMap(AnnotationService.AnnotateStructureTypesClient client)
        {
            long typeID =1;
            AnnotationService.Structure[] structures = client.GetStructuresForType(typeID);

            return LabelToStructuresMap(structures); 
        }

        public static SortedList<string, List<Structure>> LabelToStructuresMap(Structure[] structures)
        {
            SortedList<string, List<Structure>> dictLabels = new SortedList<string, List<Structure>>();
            foreach (Structure structure in structures)
            {
                string Label = BaseLabel(structure.Label);
                if (Label == null)
                    Label = "No Label";

                if (Label.Length == 0)
                    Label = "No Label";

                if (dictLabels.ContainsKey(Label))
                {
                    dictLabels[Label].Add(structure);
                }
                else
                {
                    List<Structure> listIDs = new List<Structure>();
                    listIDs.Add(structure);
                    dictLabels.Add(Label, listIDs);
                }
            }

            return dictLabels; 
        }

        /***************************************
        * Create structure types dictionary
        * *************************************/ 
        public static SortedDictionary<long, StructureType> GetStructureTypes()
        {
            using (AnnotateStructureTypesClient proxy = ConnectionFactory.CreateStructureTypesClient())
            { 
                proxy.Open();
                _IDToStructureType = GetStructureTypes(proxy);
                proxy.Close();
                return _IDToStructureType;
                
            }
        }

        public static SortedDictionary<long, StructureType> GetStructureTypes(AnnotateStructureTypesClient proxy)
        {
            SortedDictionary<long, StructureType> dictTypes = new SortedDictionary<long, StructureType>();

            StructureType[] StructureTypes = proxy.GetStructureTypes(); 

            foreach (StructureType type in StructureTypes)
            {
                dictTypes.Add(type.ID, type);
            }

            return dictTypes;
        }

        public static SortedDictionary<long, List<StructureLink>> GetLinkedStructures()
        {
            using (AnnotationService.AnnotateStructuresClient client = ConnectionFactory.CreateStructuresClient())
            {
                return GetLinkedStructures(client);
            }

        }

        public static Location[] GetLocationsForStructure(AnnotateStructuresClient proxy, long ID)
        {
            return proxy.GetLocationsForStructure(ID);
        }

        public static SortedDictionary<long, List<StructureLink>> GetLinkedStructures(AnnotateStructuresClient proxy)
        {
            StructureLink[] LinkedStructures = proxy.GetLinkedStructures();
            return GetLinkedStructures(LinkedStructures); 
        }

        public static SortedDictionary<long, List<StructureLink>> GetLinkedStructures(StructureLink[] LinkedStructures)
        { 
            SortedDictionary<long, List<StructureLink>> StructIDToLinks = new SortedDictionary<long, List<StructureLink>>();
            foreach (StructureLink link in LinkedStructures)
            {
                List<StructureLink> SourceIDList = null;
                if (!StructIDToLinks.TryGetValue(link.SourceID, out SourceIDList))
                {
                    SourceIDList = new List<StructureLink>();
                }

                SourceIDList.Add(link);
                StructIDToLinks[link.SourceID] = SourceIDList;

                List<StructureLink> TargetIDList = null;
                if (!StructIDToLinks.TryGetValue(link.TargetID, out TargetIDList))
                {
                    TargetIDList = new List<StructureLink>();
                }

                TargetIDList.Add(link);
                StructIDToLinks[link.TargetID] = TargetIDList;
            }

            return StructIDToLinks;
        }

        /// <summary>
        /// Removes []'ed text and whitespace from a label
        /// </summary>
        /// <param name="label"></param>
        public static string BaseLabel(string Label)
        {
            if (Label == null)
            {
                return "Unlabeled";
            }

            int iBracket = Label.IndexOf('[');

            if (iBracket > 0)
                Label = Label.Substring(0, iBracket - 1);

            Label = Label.Trim();

            if (Label.Length == 0)
            {
                Label = "Unlabeled"; 
            }

            return Label;
        }


    }
}