﻿using System;
using System.Diagnostics;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace AnnotationVizLib
{
    public class MorphologyTLPView : TLPView<ulong>
    {
        public readonly Scale scale;
        public readonly System.Drawing.Color structure_color; 
        
         
        protected override SortedDictionary<string, string> DefaultAttributes
        {
            get { return TLPAttributes.DefaultForMorphologyAttribute; }
        }

        public MorphologyTLPView(Scale scale, System.Drawing.Color ColorMap)
        {
            this.scale = scale;
            this.structure_color = ColorMap;

            if (ColorMap.IsEmpty)
                this.structure_color = System.Drawing.Color.Gray;
        }

        protected new TLPViewNode createNode(ulong ID)
        {
            TLPViewNode tempNode = new TLPViewNode(ID);
            addNode(ID, tempNode);
            return tempNode; 
        }

        /// <summary>
        /// Does not populate attributes since they are inherited
        /// </summary>
        public TLPViewNode CreateTLPSubgraphNode(MorphologyNode node)
        {
            return createNode(node.Key); 
        }
         
        
        public TLPViewNode CreateTLPNode(MorphologyNode node, System.Drawing.Color color)
        {
            TLPViewNode tlpnode = createNode(node.Key);
            Dictionary<string, string> NodeAttribs = new Dictionary<string, string>();
            /*IDictionary<string, string> NodeAttribs = AttributeMapper.AttribsForLabel(node..Label, TLPAttributes.StandardLabelToNodeTLPAppearance);

            if(NodeAttribs.Count == 0)
            {
                //Add default node properties 
                AttributeMapper.CopyAttributes(TLPAttributes.UnknownTLPNodeAttributes, NodeAttribs);
            }
            */

            tlpnode.Color = color; 
            NodeAttribs.Add("viewSize", NodeSize(node, scale));
            NodeAttribs.Add("viewLayout", NodeLayout(node, scale));
            NodeAttribs.Add("LocationID", node.Location.ID.ToString());
            NodeAttribs.Add("ParentID", node.Location.ParentID.ToString());
            NodeAttribs.Add("LocationInViking", NodeVikingLocation(node));

            NodeAttribs.Add("StructureURL", string.Format("http://connectomes.utah.edu/Services/RC1/ConnectomeData.svc/Locations({0}L)", node.Location.ID));

            tlpnode.AddAttributes(NodeAttribs);

            return tlpnode;
        }

        public static string NodeVikingLocation(MorphologyNode node)
        {
            AnnotationService.AnnotationPoint pos = node.Location.VolumePosition;
            return string.Format("X:{0} Y:{1} Z:{2}", pos.X, pos.Y, node.Location.Section);
        }

        public static string NodeLayout(MorphologyNode node, Scale scale)
        {
            AnnotationService.AnnotationPoint pos = node.Location.VolumePosition;
            return string.Format("({0},{1},{2})", pos.X * scale.X.Value, pos.Y * scale.Y.Value, node.Location.Section * scale.Z.Value);
        }

        public static string NodeSize(MorphologyNode node, Scale scale)
        {
            return string.Format("({0},{1},{2})", node.Location.Radius * scale.X.Value, node.Location.Radius * scale.Y.Value, 1 * scale.Z.Value);
        }

        public string LabelForNode(MorphologyNode node)
        {
            return node.Key.ToString();
        }

        public static string LinkString(AnnotationService.StructureLink link)
        {
            return link.SourceID + " -> " + link.TargetID;
        }

        /// <summary>
        /// Does not populate attributes since they are inherited
        /// </summary>
        public TLPViewEdge CreateTLPSubgraphEdge(MorphologyEdge edge)
        {
            TLPViewEdge tlpedge = null;
            try
            {
                tlpedge = this.addEdge(edge.SourceNodeKey, edge.TargetNodeKey);
            }
            catch (KeyNotFoundException e)
            {
                Trace.WriteLine(string.Format("Nodes missing for edge {0}", edge.ToString()));
                return null;
            }
            return tlpedge;
        }

        /// <summary>
        /// Create an edge between two nodes.  Returns null if the nodes do not exist
        /// </summary>
        /// <param name="edge"></param>
        /// <returns></returns>
        public TLPViewEdge CreateTLPEdge(MorphologyEdge edge)
        {
            TLPViewEdge tlpedge = null;
            try
            {
                tlpedge = this.addEdge(edge.SourceNodeKey, edge.TargetNodeKey);
            }
            catch(KeyNotFoundException e)
            {
                Trace.WriteLine(string.Format("Nodes missing for edge {0}", edge.ToString()));
                return null;
            }
            
            /*
            IDictionary<string, string> EdgeAttribs = AttributeMapper.AttribsForLabel(edge.SynapseType, TLPAttributes.StandardEdgeSourceLabelToTLPAppearance);

            if (EdgeAttribs.Count == 0)
            {
                //Add default node properties 
                AttributeMapper.CopyAttributes(TLPAttributes.UnknownTLPEdgeAttributes, EdgeAttribs);
            }

            EdgeAttribs.Add("viewLabel", edge.SynapseType);
            EdgeAttribs.Add("edgeType", edge.SynapseType);
            EdgeAttribs.Add("LinkedStructures", LinkedStructures(edge));
            
            tlpedge.AddAttributes(EdgeAttribs);
            
            */

            return tlpedge;
        }

        public static System.Drawing.Color GetStructureColor(MorphologyGraph graph, StructureMorphologyColorMap colorMap)
        {
            if (colorMap == null)
                return System.Drawing.Color.Empty;

            return colorMap.GetColor(graph); 
        }

        public static MorphologyTLPView ToTLP(MorphologyGraph graph,  Scale scale, StructureMorphologyColorMap colorMap)
        {
            MorphologyTLPView view = new MorphologyTLPView(scale, GetStructureColor(graph, colorMap));

            AddAllSubgraphNodesAndEdges(view, graph, colorMap);

            //AssignNodesToSubgraphs(view, graph);

            return view;
        }

        private static void AddAllSubgraphNodesAndEdges(MorphologyTLPView view, MorphologyGraph structuregraph, StructureMorphologyColorMap colorMap)
        {
            System.Drawing.Color color = colorMap.GetColor(structuregraph);

            foreach (MorphologyNode node in structuregraph.Nodes.Values)
            {
                view.CreateTLPNode(node, color);
            }

            foreach (MorphologyEdge edge in structuregraph.Edges.Values)
            {
                view.CreateTLPEdge(edge);
            }

            foreach (ulong subgraph_id in structuregraph.Subgraphs.Keys)
            { 
                MorphologyGraph subgraph = structuregraph.Subgraphs[subgraph_id];
                //MorphologyTLPView subgraph_view = new MorphologyTLPView(view.scale, GetStructureColor(subgraph, colorMap));
                
                //CreateSubgraph(subgraph_view,subgraph); 

                AddAllSubgraphNodesAndEdges(view, subgraph, colorMap);
                //view.AddSubGraph(subgraph_id, subgraph_view);
            }
        }

        private static void AssignNodesToSubgraphs(MorphologyTLPView view, MorphologyGraph structuregraph, StructureMorphologyColorMap colorMap)
        {
            foreach (MorphologyNode node in structuregraph.Nodes.Values)
            {
                view.CreateTLPSubgraphNode(node);
            }

            foreach (MorphologyEdge edge in structuregraph.Edges.Values)
            {
                view.CreateTLPSubgraphEdge(edge);
            }

            foreach (ulong subgraph_id in structuregraph.Subgraphs.Keys)
            {
                MorphologyGraph subgraph = structuregraph.Subgraphs[subgraph_id];
                MorphologyTLPView subgraph_view = new MorphologyTLPView(view.scale, GetStructureColor(subgraph, colorMap));
               
                //CreateSubgraph(subgraph_view,subgraph); 

                AssignNodesToSubgraphs(subgraph_view, subgraph, colorMap);
                view.AddSubGraph(subgraph_id, subgraph_view);
            }
        }
    }
}