USE [Rabbit]
GO
/****** Object:  StoredProcedure [dbo].[SelectNumConnectionsPerStructure]    Script Date: 08/31/2012 12:02:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SelectNumConnectionsPerStructure]
			AS
			 (
 select CS.ParentID as StructureID, ParentStructure.Label as Label, COUNT(CS.ParentID) as NumConnections 
 from Structure CS
	INNER JOIN Structure ParentStructure
	ON CS.ParentID = ParentStructure.ID
 WHERE (
	CS.ID in (
	Select SourceID from StructureLink
	 WHERE (SourceID in 
		(
			SELECT S.ID
			FROM [Rabbit].[dbo].[Structure] S) 
		)
		)
	OR (
	CS.ID in (
	Select TargetID from StructureLink
	 WHERE (TargetID in 
		(SELECT S.ID
			FROM [Rabbit].[dbo].[Structure] S) 
			)
		)
	  )
	)
group by CS.ParentID, ParentStructure.Label

)
order by NumConnections DESC