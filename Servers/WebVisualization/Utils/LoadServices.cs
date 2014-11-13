using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Xml;
using System.Xml.Linq;

namespace ConnectomeViz.Models
{
    public class LoadServices
    {
        private static LoadServices instance = null;

        private LoadServices()
        { }

        public static void Initialize()
        {           

                instance = new LoadServices();
                instance.Task();
            
                      
        }

        public void Task()
        {
            string path = State.filesPath + "\\Services.xml";

            XDocument xmlDoc = XDocument.Load(path);

            var labs = from lab in xmlDoc.Descendants("Lab")
                       select new
                           {
                               labName = lab.Attribute("name"),
                               labServer = lab.Attribute("server"),
                               volumeName = lab.Element("Volume").Attribute("name"),
                               databaseName = lab.Element("Volume").Attribute("database"),
                               serviceURL = lab.Element("Volume").Element("Service").Attribute("path").ToString(),

                           };

            var ll = from lab in xmlDoc.Descendants("Lab")
                     select lab;

            State.serviceDictionary = new Dictionary<string, string>();

            State.labsDictionary = new Dictionary<string, string[]>();

            State.serverDictionary = new Dictionary<string, string>();

            State.databaseDictionary = new Dictionary<string, string>();

            foreach (var lab in ll)
            {
                string labname = lab.Attribute("name").Value.ToString();
                string server = lab.Attribute("server").Value.ToString();

                var res = from a in lab.Descendants("Volume")
                          select new
                          {
                              volumeName = a.Attribute("name").Value,
                              databaseName = a.Attribute("database").Value,
                              serviceURL = a.Element("Service").Attribute("path").Value.ToString()

                          };

              

                List<string> names = new List<string>();

                foreach (var result in res)
                {
                    names.Add(result.volumeName.ToString());
                    try
                    {
                        State.serviceDictionary.Add(result.volumeName.ToString(), result.serviceURL.ToString());
                    }
                    catch (Exception e)
                    {
                        State.serviceDictionary[result.volumeName.ToString()] = result.serviceURL.ToString();
                    }

                    try
                    {
                        State.databaseDictionary.Add(result.volumeName.ToString(), result.databaseName.ToString());
                    }
                    catch (Exception e)
                    {
                        State.databaseDictionary[result.volumeName.ToString()] = result.databaseName.ToString();
                    }


                }

                try
                {
                    State.labsDictionary.Add(labname, names.ToArray());
                    State.serverDictionary.Add(labname, server);
                }
                catch (Exception e)
                {
                    State.labsDictionary[labname] = names.ToArray();
                    State.serverDictionary[labname] = server;
                }

            }

            State.selectedLab = "MarcLab(connectomes.utah.edu)";

            State.selectedService = "Rabbit(MarcLab)";

        }
                    
        
        }
    }
