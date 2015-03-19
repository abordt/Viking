DECLARE @DeleteID bigint
Set @DeleteID = 268

delete from LocationLink
where A in 
(
Select ID from Location 
where ParentID = @DeleteID ) 

delete from LocationLink
where B in 
(
Select ID from Location 
where ParentID = @DeleteID ) 

delete from StructureLink
where SourceID in 
(select ID from Structure where ParentID = @DeleteID)

delete from StructureLink
where TargetID in 
(select ID from Structure where ParentID = @DeleteID)

delete from Location
where ParentID=@DeleteID

delete from Structure
where ParentID = @DeleteID

delete from Structure
where ID=@DeleteID
  