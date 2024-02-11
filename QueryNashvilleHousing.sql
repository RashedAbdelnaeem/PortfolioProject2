--First Cleaning 
------------------------
select * from..HousingInNashville ;
select *
--from..HousingInNashville 
--where PropertyAddress is null
--order by ParcelID
--;

--join the table to it self to look at dublicate value and fix null 
select a.[UniqueID ],a.ParcelID , a.PropertyAddress ,b.[UniqueID ], b.ParcelID ,b.PropertyAddress , isnull (a.PropertyAddress , b.PropertyAddress)
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
--
--select SoldAsVacant , 
--case when SoldAsVacant = 'N' then 'No'
--     when SoldAsVacant = 'Y' then 'Yes'
--     Else SoldAsVacant
--     End 
--from..HousingInNashville ;


select OwnerAddress
from..HousingInNashville ;

--alter table HousingInNashville 
--add  ownerSpiltAddress Nvarchar (255) ;

--alter table HousingInNashville 
--add  ownerSpiltCity Nvarchar (255) ;

--
select ownerSpiltCity
from..HousingInNashville ;
--
--alter table HousingInNashville 
--add  ownerSpiltState Nvarchar (255) ;
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
-- replace unknown city by null 
--UPDATE HousingInNashville
--SET property_city = null  
--where [UniqueID ] = 46010 ;

-----end of cleaning data

----------------start analysis------
select * from..HousingInNashville ;

---count of properties sold as vacant
select distinct SoldAsVacant , count (SoldAsVacant) as count_
from..HousingInNashville 
where SoldAsVacant = 'Yes'
group by SoldAsVacant
order by 2
;
-- properties uses in Nashville City
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

--------------
--biggest cities in  Tennessee state per properties count 
select ownerSpiltCity ,count (UniqueID) as "properties count"
from..HousingInNashville 
where ownerSpiltCity is not null
group by ownerSpiltCity
order by 2 desc ;

---- 
--schadual work = clean values = null in property_city column and likewyse 

select * from dbo.HousingInNashville where property_city is null  ;
--- max,min avg properties price in cities in  Tennessee state
select property_city , max(SalePrice)  MaxPricePerCity, min(SalePrice) MinPricePerCity, avg(SalePrice) AvgPricePerCity
from dbo.HousingInNashville 
group by property_city
order by 1
;
-- max,min avg properties price in street ,road and zones
select PropertyAddress , max(SalePrice) over (partition by SalePrice )  MaxPricePerCity,
min(SalePrice) over (partition by SalePrice ) MinPricePerCity, 
avg(SalePrice) over (partition by SalePrice ) AvgPricePerCity
from dbo.HousingInNashville 
order by 1
;
-- test 

