using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Diagnostics;

namespace AnnotationUtils
{
    static class AttributeMaps
    {
        public static SortedDictionary<string, string> StandardGraphAttributes = new SortedDictionary<string, string>()
        {
            {"splines", "true"},
            {"dpi", "600"},
            {"ratio", "compress"},
            {"regular", "true"}, 
            //{"page", "11,8.5"},
            //{"size", "10,7.5"}, 
            {"center", "true"},
            {"minlen", "1"},
            {"sep", "1"},
            {"ranksep", "0.1"},
            {"nodesep", "0.5"}, 
            {"mode", "major"},
            {"model", "subset"},
            {"maxiter", "10000"}
        };

        public static SortedDictionary<string, string> StandardNodeAttributes = new SortedDictionary<string,string>() {
            {"peripheries", "3"},
            {"fontcolor", "white"},
            {"style", "filled"},
            {"penwidth", "0.0"},
            {"fontname", "Helvetica"}
        };

        /// <summary>
        /// A mapping of labels to node properties.  
        /// An exact match is checked first, if it does not exist the
        /// we search the keys in reverse sorted order.  The first partial match
        /// has its attributes returned.
        /// </summary>
        public static IDictionary<string, SortedList<string, string>> StandardLabelToAppearance = new SortedDictionary<string, SortedList<string, string>>()
        {   
            {"AXON", new SortedList<string,string> {
                            {"fillcolor", "Red3"},
                            {"shape", "hexagon"}
                }
            },
            {"DENDRITE", new SortedList<string,string> {
                            {"fillcolor", "green3"} 
                }
            },
            {"CBAB", new SortedList<string,string> {
                            {"fillcolor", "green4"} 
                }
            },
            {"GBC", new SortedList<string,string> {
                            {"fillcolor", "cadetblue"} 
                }
            },
            {"CBB", new SortedList<string,string> {
                            {"fillcolor", "cadetblue"} 
                }
            },
            {"AII", new SortedList<string,string> {
                            {"fillcolor", "yellow3"},
                            {"shape", "hexagon"}
                }
            },
            {"S1", new SortedList<string,string> {
                            {"fillcolor", "palevioletred1"},
                            {"shape", "diamond"}
                }
            },
            {"S2", new SortedList<string,string> {
                            {"fillcolor", "palevioletred4"},
                            {"shape", "diamond"}
                }
            },
            {"AI", new SortedList<string,string> {
                            {"fillcolor", "orchid"},
                            {"shape", "diamond"}
                }
            },
            {"STARBURST", new SortedList<string,string> {
                           {"fillcolor", "hotpink"},
                           {"shape", "diamond"}
                }
            },
            {"IAC", new SortedList<string,string> {
                            {"fillcolor", "brown1"},
                            {"shape", "invtrapezium"}
                }
            },
            {"ROD BC", new SortedList<string,string> {
                            {"fillcolor", "purple"} 
                }
            },
            {"OFF", new SortedList<string,string> {
                            {"fillcolor", "blue"} 
                }
            },
            {"CBA", new SortedList<string,string> {
                            {"fillcolor", "blue"} 
                }
            },
            {"BC", new SortedList<string,string> {
                            {"fillcolor", "grey"} 
                }
            },
            {"AXC", new SortedList<string,string> {
                            {"fillcolor", "orange"},
                            {"shape", "doubleoctagon"}
                }
            },
            {"YAC", new SortedList<string,string> {
                            {"fillcolor", "Red3"},
                            {"shape", "triangle"}
                }
            },
            {"GABA", new SortedList<string,string> {
                            {"fillcolor", "Red3"},
                            {"shape", "triangle"}
                }
            },
            {"GLY", new SortedList<string,string> {
                            {"fillcolor", "green3"},
                            {"shape", "invtriangle"}
                }
            },
            {"GAC", new SortedList<string,string> {
                            {"fillcolor", "green3"},
                            {"shape", "invtriangle"}
                }
            },
            {"AC", new SortedList<string,string> {
                            {"fillcolor", "darkkhaki"},
                            {"shape", "ellipse"}
                }
            },
            {"GC", new SortedList<string,string> {
                            {"fillcolor", "saddlebrown"}
                }
            }
        };

        public static IDictionary<string, SortedList<string, string>> StandardEdgeLabelToAppearance = new SortedDictionary<string, SortedList<string, string>>()
        {   
            {"RIBBON SYNAPSE", new SortedList<string,string> {
                            {"dir", "forward"},
                            {"arrowhead", "normal"},
                            {"arrowtail", "none"},
                            {"color", "chartreuse4"}
                }
            },
            {"CONVENTIONAL", new SortedList<string,string> {
                            {"dir", "forward"},
                            {"arrowhead", "tee"},
                            {"arrowtail", "none"},
                            {"color", "red3"}
                }
            },
            {"BC CONVENTIONAL", new SortedList<string,string> {
                            {"dir", "forward"},
                            {"arrowhead", "normal"},
                            {"arrowtail", "none"},
                            {"color", "chartreuse4"}
                }
            },
            {"GAP JUNCTION", new SortedList<string,string> {
                            {"dir", "both"},
                            {"arrowhead", "open"},
                            {"arrowtail", "open"},
                            {"color", "goldenrod4"}
                }
            },
            {"FRONTIER", new SortedList<string,string> {
                            {"dir", "forward"},
                            {"arrowhead", "none"},
                            {"arrowtail", "none"},
                            {"color", "white"}
                }
            },
            {"UNKNOWN", new SortedList<string,string> {
                            {"dir", "forward"},
                            {"arrowhead", "none"},
                            {"arrowtail", "none"},
                            {"color", "black"}
                }
            }
        };

        public static IDictionary<string, string> AttribsForLabel(string label, IDictionary<string, SortedList<string, string>> LabelToAttribMap)
        {
            label = label.ToUpper(); 

            if (LabelToAttribMap.ContainsKey(label))
                return LabelToAttribMap[label];

            //Search the dictionary in reverse sorted order so the longest strings
            //are checked for a match before the shortest.

            List<string> keys = LabelToAttribMap.Keys.ToList<string>();

            keys.Sort();
            keys.Reverse();

            foreach (string key in keys)
            {
                if(label.Contains(key))
                    return LabelToAttribMap[key];
            }

            return null;
        }
    }
}
