--First Cleaning 
------------------------
select * from..HousingInNashville ;

select *
from..HousingInNashville 
where PropertyAddress is null
order by ParcelID
;
--join the table to it self to look at dublicate value and fix null 
select a.ParcelID , a.PropertyAddress , b.ParcelID ,b.PropertyAddress , isnull (a.PropertyAddress , b.PropertyAddress)
from..HousingInNashville as a 
join ..HousingInNashville as b 
on a.ParcelID = b.ParcelID 
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is not null ;

--UPDATE a 
--set PropertyAddress = isnull (a.PropertyAddress , b.PropertyAddress)
--from..HousingInNashville as a 
--join ..HousingInNashville as b 
--on a.ParcelID = b.ParcelID 
--and a.[UniqueID ] <> b.[UniqueID ]
--where a.PropertyAddress is null ;







--REPLACE(string, old_string, new_string)
--SELECT REPLACE('SQL Tutorial', 'T', 'M');

 --PARSENAME ('object_name' , object_piece ) 
--SELECT PARSENAME('AdventureWorksPDW2012.dbo.DimCustomer', 1) AS 'Object Name';
--SELECT PARSENAME('AdventureWorksPDW2012.dbo.DimCustomer', 2) AS 'Schema Name';
--SELECT PARSENAME('AdventureWorksPDW2012.dbo.DimCustomer', 4) AS 'Server Name';

select OwnerAddress
from..HousingInNashville ;

--select parsename (replace(OwnerAddress , ',' , '.'),3) as Address_ 
--,parsename (replace(OwnerAddress , ',' , '.'),2) as City
--,parsename (replace(OwnerAddress , ',' , '.'),1) As State_
--from..HousingInNashville ;

--alter table HousingInNashville 
--add  ownerSpiltAddress Nvarchar (255) ;

--update HousingInNashville  
--set ownerSpiltAddress =  parsename (replace(OwnerAddress , ',' , '.'),3);

select ownerSpiltAddress
from..HousingInNashville ;
---
--alter table HousingInNashville 
--add  ownerSpiltCity Nvarchar (255) ;
--
--update HousingInNashville  
--set ownerSpiltCity =  parsename (replace(OwnerAddress , ',' , '.'),2);
--
select ownerSpiltCity
from..HousingInNashville ;
--
--alter table HousingInNashville 
--add  ownerSpiltState Nvarchar (255) ;

--update HousingInNashville  
--set ownerSpiltState =  parsename (replace(OwnerAddress , ',' , '.'),1);
select ownerSpiltState
from..HousingInNashville ;
---
select distinct SoldAsVacant , count (SoldAsVacant)
from..HousingInNashville 
group by SoldAsVacant
order by 2
;
select SoldAsVacant , 
case when SoldAsVacant = 'N' then 'No'
     when SoldAsVacant = 'Y' then 'Yes'
     Else SoldAsVacant
     End 
from..HousingInNashville ;

--update HousingInNashville 
--set SoldAsVacant = case when SoldAsVacant = 'N' then 'No'
--     when SoldAsVacant = 'Y' then 'Yes'
--     Else SoldAsVacant
--     End ;

---remove dublicates
select * , row_Number() over (
partition by  ParcelID ,
              propertyAddress ,
			 SalePrice ,
			 LegalReference 
			 order by UniqueID
)  row_num

from..HousingInNashville 
order by ParcelID  desc
;
--where row_num > 1
--with row_numCTE as (
--select * , row_Number() over (
--partition by  ParcelID ,
--              propertyAddress ,
--			 SalePrice ,
--			 LegalReference 
--			 order by UniqueID
--)  row_num
--from..HousingInNashville 
--)
--delete  from row_numCTE
--where row_num > 1 

--;

with row_numCTE as (
select * , row_Number() over (
partition by  ParcelID ,
              propertyAddress ,
			 SalePrice ,
			 LegalReference 
			 order by UniqueID
)  row_num
from..HousingInNashville 
)
select *  from row_numCTE
where row_num > 1 

;
--Second analysis data 
------------------------                    -------------------------------hhhh--------------------
select * from..HousingInNashville ;

-- property uses in Nashville City
select LandUse , count(LandUse) as LandUsesCount 
from..HousingInNashville 
group by LandUse
order by 2;

----the biggest  property per acreage
select  PropertyAddress, property_city  , SalePrice , Acreage , Bedrooms , FullBath , HalfBath , OwnerName , LandUse
from..HousingInNashville 
where Bedrooms is not null
order by Bedrooms  desc
;
--the highest price for  sold property
select  PropertyAddress, property_city  , SalePrice , Acreage , Bedrooms , FullBath , HalfBath , OwnerName , LandUse
from..HousingInNashville 
where Bedrooms is not null
order by SalePrice  desc
;
--- bigest Cities per property count 
select  property_city, count (property_city) as theCount  
from..HousingInNashville 
group by property_city 
order by 2  desc
;

-- Year built per count
select  YearBuilt , count (property_city) as propertyCount
from..HousingInNashville 
where YearBuilt is not null
group by YearBuilt
order by YearBuilt
;
-- in which year many properties had built
select  YearBuilt , count (property_city) as propertyCount
from..HousingInNashville 
where YearBuilt is not null
group by YearBuilt
order by 2 desc
;
----the most profitable property
select   UniqueID , PropertyAddress, property_city , (SalePrice - TotalValue) as profit
from..HousingInNashville 
order by profit desc
;
-- properties value per Cities
select property_city , count(property_city) as propertiesCount , sum (SalePrice) totalPrperiesValue
from..HousingInNashville 
where property_city is not null 
group by property_city
order by 3 	desc ;
-- replace unknown city by null 

--UPDATE HousingInNashville
--SET property_city = null  
--where [UniqueID ] = 46010 ;

--select  [UniqueID ] ,property_city 
--from..HousingInNashville
--where [UniqueID ] = 46010 ;
----property_city like '%UNk%';



