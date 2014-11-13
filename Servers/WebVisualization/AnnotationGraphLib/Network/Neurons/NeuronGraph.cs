using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GraphLib;
using AnnotationUtils.AnnotationService;
using System.Diagnostics;

namespace AnnotationUtils.Network.Neurons
{
    public class NeuronEdge : Edge<long>
    {
        public string SynapseType;

        public NeuronEdge(long SourceKey, long TargetKey, string SynapseType)
            : base(SourceKey, TargetKey)
        {
            this.SynapseType = SynapseType;
        }

        public override string ToString()
        {
            return this.SourceNodeKey.ToString() + " -> " + this.TargetNodeKey.ToString() + " via " + this.SynapseType;
        }
    }

    public class NeuronNode : Node<long, NeuronEdge>
    {
        //Structure this node represents
        Structure Structure;

        public NeuronNode(long key, Structure value)
            : base(key)
        {
            this.Structure = value;
            
        }

        public override string ToString()
        {
            return this.Key.ToString() + " : " + Structure.Label;
        }
    }

    class NeuronGraph : Graph<long, NeuronNode, NeuronEdge>
    {
    }
}
