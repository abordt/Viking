﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Viking.Common;
using System.Windows.Forms;
using WebAnnotationModel;
using System.Diagnostics;
using Geometry;

namespace WebAnnotation.ViewModel
{
    /// <summary>
    /// This class represents a link between locations. This object is a little unique because it is
    /// not tied to the database object like the other *obj classes
    /// </summary>
    public class LocationLink : Viking.Objects.UIObjBase
    {
        public override int GetHashCode()
        {
            return A.GetHashCode();
        }

        public override bool Equals(object obj)
        {
            LocationLink link = obj as LocationLink;
            if (link == null)
                return false;

            return (link.A.ID == A.ID && link.B.ID == B.ID); 
        }

        public static bool operator ==(LocationLink A, object B)
        {
            if (System.Object.ReferenceEquals(A, B))
            {
                return true;
            }

            if ((object)A != null)
                return A.Equals(B);

            return false;
        }

        public static bool operator !=(LocationLink A, object B)
        {
            if (System.Object.ReferenceEquals(A, B))
            {
                return false;
            }

            if ((object)A != null)
                return !A.Equals(B);

            return true;
        }

        public override string ToString()
        {
            return A.ID.ToString() + " <-> " + B.ID.ToString() + " Sections: " + minSection.ToString() + "-" + maxSection.ToString();
        }
        
        /// <summary>
        /// LocationOnSection is the location on the section being viewed
        /// </summary>
        public LocationObj A; 

        /// <summary>
        /// LocationOnSection is the location on the section being viewed
        /// </summary>
        public LocationObj B;

        public int minSection { get { return A.Section < B.Section ? A.Section : B.Section; } }
        public int maxSection { get { return A.Section > B.Section ? A.Section : B.Section; } }

        private RoundLineCode.RoundLine _lineGraphic = null;
        public RoundLineCode.RoundLine lineGraphic
        {
            get
            {
                if (_lineGraphic == null)
                {
                    _lineGraphic = new RoundLineCode.RoundLine((float)A.VolumePosition.X,
                                                      (float)A.VolumePosition.Y,
                                                      (float)B.VolumePosition.X,
                                                      (float)B.VolumePosition.Y);
                }

                return _lineGraphic;
            }

        }
        
        public double Radius
        {
            get
            {
                return Math.Min(A.Radius,B.Radius)/2f;
            }
        }

        public LocationLink(LocationObj LocOne, LocationObj LocTwo)
        {
            if (LocOne == null)
                throw new ArgumentNullException("LocOne");

            if (LocTwo == null)
                throw new ArgumentNullException("LocTwo"); 

            Debug.Assert(LocOne != LocTwo);
            this.A = LocOne.ID < LocTwo.ID ? LocOne : LocTwo;
            this.B = LocOne.ID > LocTwo.ID ? LocOne : LocTwo; 

            
           // lineSegment = new Geometry.GridLineSegment(A.VolumePosition, B.VolumePosition); 
        }

        /// <summary>
        /// Return true if the locations overlap when viewed from the passed section
        /// </summary>
        /// <param name="sectionNumber"></param>
        /// <returns></returns>
        public bool LinksOverlap(int sectionNumber)
        { 
            //Don't draw if the link falls within the radius of the location we are drawing
            if (A.Section == sectionNumber)
            {
                return GridVector2.Distance(A.VolumePosition, B.VolumePosition) <= A.Radius + Location_CanvasViewModel.CalcOffSectionRadius((float)B.Radius);
            }

            if (B.Section == sectionNumber)
            {
                return GridVector2.Distance(A.VolumePosition, B.VolumePosition) <= B.Radius + Location_CanvasViewModel.CalcOffSectionRadius((float)A.Radius);
            } 

            return false; 
        }

        /// <summary>
        /// Return true if the link can be seen at the given downsample level
        /// </summary>
        /// <param name="Downsample"></param>
        /// <returns></returns>
        public bool LinksVisible(double Downsample)
        {
            return Location_CanvasViewModel.CalcOffSectionRadius(this.Radius) / Downsample > 2.0;
        }

        #region IUIObjectBasic Members
        
        public override System.Windows.Forms.ContextMenu ContextMenu
        {
            get
            {
                ContextMenu menu = new ContextMenu();

                MenuItem menuSeperator = new MenuItem(); 
                MenuItem menuDelete = new MenuItem("Delete Link", ContextMenu_OnDelete);

                menu.MenuItems.Add(menuSeperator); 
                menu.MenuItems.Add(menuDelete); 

                return menu; 
            }
        }

        public override string ToolTip
        {
            get { return A.ID.ToString() + " -> " + B.ID.ToString(); }
        }

        public override void Save()
        {
            throw new NotImplementedException();
        }

        #endregion

        protected void ContextMenu_OnDelete(object sender, EventArgs e)
        {
            Delete();
        }

        public override void Delete()
        {
            CallBeforeDelete(); 

            Store.LocationLinks.DeleteLink(this.A.ID, this.B.ID);

            CallAfterDelete();
        }

    }
}
