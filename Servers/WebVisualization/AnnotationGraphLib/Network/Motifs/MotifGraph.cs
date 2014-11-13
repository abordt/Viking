using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GraphLib;
using AnnotationUtils.AnnotationService;
using System.Diagnostics;


namespace AnnotationUtils
{
    public class MotifEdge : Edge<string>
    {
        public string SynapseType;

        public MotifEdge(string SourceKey, string TargetKey, string SynapseType)
            : base(SourceKey, TargetKey)
        {
            this.SynapseType = SynapseType;
        }

        public override string ToString()
        {
            return this.SourceNodeKey + " -> " + this.TargetNodeKey + " via " + this.SynapseType;
        }
    }

    public class MotifNode : Node<string, MotifEdge>
    {
        //Structures that belong to this node
        public List<Structure> Structures;

        public MotifNode(string key, IEnumerable<Structure> value)
            : base(key)
        {
            this.Structures = new List<Structure>();
            this.Structures.AddRange(value);
        }

        public override string ToString()
        {
            string Label = this.Key;

            foreach (Structure s in Structures)
            {
                Label = Label + ", " + s.ID.ToString();
            }

            return Label;
        }
    } 
    

    public class MotifGraph : Graph<string, MotifNode, MotifEdge>
    {
         
        public SortedList<string, List<AnnotationService.Structure>> LabelToStructures = null; 

        SortedDictionary<long, Structure> ChildIDToParent = new SortedDictionary<long,Structure>();
        SortedDictionary<long, Structure> IDToStructure = new SortedDictionary<long,Structure>();

        SortedDictionary<long, StructureType> TypeIDToType;

        public MotifGraph()
        {
            
        }

        public override string ToString()
        {
            List<string> AlreadyAdded = new List<string>();
            
            foreach (MotifEdge e in this.Edges)
            {
                string EdgeLabel = e.ToString();
                if (!AlreadyAdded.Contains(EdgeLabel))
                {
                    
                    AlreadyAdded.Add(EdgeLabel);
                }
            }

            AlreadyAdded.Sort(); 

            string Label = "";
            foreach (string l in AlreadyAdded)
            {
                Label = Label + l + '\n'; 
            }

            return Label; 
        }

        public bool BuildGraph(string Endpoint, System.Net.NetworkCredential userCredentials)
        {
            ConnectionFactory.SetConnection(Endpoint, userCredentials);
            
            List<long> UnmappedStructures = null;

            using (AnnotateStructureTypesClient proxy = ConnectionFactory.CreateStructureTypesClient())
            {
                this.TypeIDToType = Queries.GetStructureTypes(proxy);
                this.LabelToStructures = Queries.LabelToStructuresMap(proxy);
                  
                UnmappedStructures = new List<long>(LabelToStructures.Count * 4);
            }

            using ( AnnotateStructuresClient proxy = ConnectionFactory.CreateStructuresClient())
            {
                foreach (string Label in LabelToStructures.Keys)
                {
                    List<long> structIDs = new List<long>(LabelToStructures[Label].Count);
                    foreach (Structure s in LabelToStructures[Label])
                    {
                        structIDs.Add(s.ID);
                        IDToStructure.Add(s.ID, s); 
                    }

                    List<Structure> structures = new List<Structure>(structIDs.Count);
                    Structure[] ServerStructureArray = proxy.GetStructuresByIDs(structIDs.ToArray(), true);
                    structures.AddRange(ServerStructureArray); 

                    for (int iStruct = 0; iStruct < structures.Count; iStruct++)
                    {
                        Structure s = structures[iStruct];

                        if (s.ChildIDs.Length == 0)
                        {
                            structures.RemoveAt(iStruct);
                            iStruct--;
                            continue;
                        }

                        //We remove structures which are not linked from our search list.
                        foreach (long childID in s.ChildIDs)
                        {
                            UnmappedStructures.Add(childID);
                            ChildIDToParent[childID] = s;
                        }
                    }

                    //Ok, something useful was added.  Create a node for this label.
                    if (structures.Count == 0)
                    {
                        continue;
                    }

                    MotifNode node = new MotifNode(Label, structures);

                    this.AddNode(node);
                }
            }

            //OK, build some edges
            this.AddEdges(null, UnmappedStructures);

            return true; 
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="proxy">Proxy if it already exists, otherwise one is constructed</param>
        /// <param name="UnmappedStructures"></param>
        private void AddEdges(AnnotationService.AnnotateStructuresClient proxy, List<long> UnmappedStructures)
        {
            List<Structure> structures = new List<Structure>(UnmappedStructures.Count);

            while (UnmappedStructures.Count > 0)
            {
                int numElementsToRemove = 4096;
                if (UnmappedStructures.Count < numElementsToRemove)
                    numElementsToRemove = UnmappedStructures.Count;

                List<long> RequestArray = new List<long>(numElementsToRemove);
                RequestArray.AddRange(UnmappedStructures.Take(numElementsToRemove));
                UnmappedStructures.RemoveRange(0, numElementsToRemove); 
                Structure[] newStructures = null;

                using (AnnotateStructuresClient proxyb = ConnectionFactory.CreateStructuresClient())
                {
                    newStructures = proxyb.GetStructuresByIDs(RequestArray.ToArray(), false);
                }

                structures.AddRange(newStructures);

                Trace.WriteLine("Fetched " + structures.Count.ToString() + " structures"); 
            }

            UnmappedStructures.Clear(); 
            foreach (Structure s in structures)
            {
                foreach (StructureLink link in s.Links)
                {
                    if (!ChildIDToParent.ContainsKey(link.SourceID))
                    {
                        UnmappedStructures.Add(link.SourceID);
                    }

                    if (!ChildIDToParent.ContainsKey(link.TargetID))
                    {
                        UnmappedStructures.Add(link.TargetID);
                    }
                }
            }

            Structure[] UnknownLinkedStructures;
            using (AnnotateStructuresClient proxyc = ConnectionFactory.CreateStructuresClient())
            {
                UnknownLinkedStructures = proxyc.GetStructuresByIDs(UnmappedStructures.ToArray(), false);
            }

            UnmappedStructures.Clear();

            List<long> UnknownParents = new List<long>();
            foreach (Structure s in UnknownLinkedStructures)
            {
                if (s.ParentID.HasValue)
                {
                    bool KnownParent = this.IDToStructure.ContainsKey(s.ParentID.Value);

                    if (!KnownParent)
                    {
                        using (AnnotateStructuresClient proxyd = ConnectionFactory.CreateStructuresClient())
                        {
                            Structure UnknownParent = proxyd.GetStructureByID(s.ParentID.Value, false);
                            this.ChildIDToParent[s.ID] = UnknownParent;
                            this.IDToStructure[UnknownParent.ID] = UnknownParent;
                            Trace.WriteLine("Fetched missing parent, " + UnknownParent.ID.ToString() + " - " + UnknownParent.Label); 
                        }
                    }
                    else
                    {
                        Structure parent = this.IDToStructure[s.ParentID.Value];
                        this.ChildIDToParent[s.ID] = parent;
                    }
                }
                else
                {
                    if(!IDToStructure.ContainsKey(s.ID))
                        this.IDToStructure.Add(s.ID, s);
                    else
                        Trace.WriteLine("Found parent twice, " + s.ID.ToString() + " - " + s.Label); 
                }
            }

            foreach (Structure s in structures)
            {
                //Figure out the links if they are known
                foreach (StructureLink link in s.Links)
                { 
                    if(s.ID == link.SourceID)
                    {
                        try
                        {
                            StructureType type = TypeIDToType[s.TypeID];
                            string ConnectionLabel = type.Name;

                            Structure ParentOfSource = ChildIDToParent[link.SourceID];
                            Structure ParentOfTarget = ChildIDToParent[link.TargetID]; 
    
                            string SourceLabel = Queries.BaseLabel(ParentOfSource.Label);
                            string TargetLabel = Queries.BaseLabel(ParentOfTarget.Label);

                            MotifEdge edge = new MotifEdge(SourceLabel, TargetLabel, ConnectionLabel);

                            this.Edges.Add(edge); 
                        }
                        
                        catch(System.Collections.Generic.KeyNotFoundException e)
                        {
                            //Add it to the UnmappedStructures pile
                            //Debug.Fail("Why do we not have a mapping for this object, DB change during query? " + e.Message);
                            continue; 
                        }
                    }
                }
            }
            
            //OK, we are done.  What is the graph?
            Trace.Write(this.ToString());
        }
    }
}
