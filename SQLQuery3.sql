/*

Cleaning Data in SQL Queries

*/

select * from PortfolioProject2.dbo.NashvilleHousing
-------------------------------------------------------------------------------------------------

--Standardize Data Format

select SaleDate,CONVERT(Date,SaleDate) from PortfolioProject2.dbo.NashvilleHousing

--alter table NashvilleHousing drop column SaleDateConverted

update NashvilleHousing set Date_Converted_For_Sale = convert(date,SaleDate)

select * from NashvilleHousing

-------------------------------------------------------------------------------------------------

--Populate Property Address data

select * from PortfolioProject2.dbo.NashvilleHousing 
--where PropertyAddress is null
order by ParcelID

select * from PortfolioProject2.dbo.NashvilleHousing a
join PortfolioProject2.dbo.NashvilleHousing b on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ] where a.PropertyAddress is null

update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject2.dbo.NashvilleHousing a
join PortfolioProject2.dbo.NashvilleHousing b on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ] where a.PropertyAddress is null


------------------------------------------------------------------------------------------------

--Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress from PortfolioProject2.dbo.NashvilleHousing

Select substring(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)as Address,
substring(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress)) as Address
from PortfolioProject2.dbo.NashvilleHousing

--alter table NashvilleHousing add PropertySplitAddress Nvarchar(255);

update NashvilleHousing set PropertySplitAddress = substring(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

--alter table NashvilleHousing add PropertySplitCity Nvarchar(255);

update NashvilleHousing set PropertySplitCity = substring(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress))

select * from NashvilleHousing

select OwnerAddress from PortfolioProject2.dbo.NashvilleHousing

select parsename(replace(OwnerAddress,',','.'),3),
parsename(replace(OwnerAddress,',','.'),2),
parsename(replace(OwnerAddress,',','.'),1)
from PortfolioProject2.dbo.NashvilleHousing

--alter table NashvilleHousing add OwnerSplitAddress Nvarchar(255);
--alter table NashvilleHousing add OwnerSplitCity Nvarchar(255);
--alter table NashvilleHousing add OwnerSplitState Nvarchar(255);

update NashvilleHousing set OwnerSplitAddress = parsename(replace(OwnerAddress,',','.'),3)
update NashvilleHousing set OwnerSplitCity = parsename(replace(OwnerAddress,',','.'),2)
update NashvilleHousing set OwnerSplitState = parsename(replace(OwnerAddress,',','.'),1)

select * from NashvilleHousing

--Change Y and N to Yes and No in 'Sold as Vacant' field
select distinct(SoldAsVacant),count(SoldAsVacant) from NashvilleHousing group by(SoldAsVacant) order by 2

select * from NashvilleHousing

select SoldAsVacant ,
CASE when SoldAsVacant = 'Y' THEN 'YES'
WHEN SoldAsVacant = 'N' THEN 'NO'
ELSE SoldAsVacant 
END
from PortfolioProject2.dbo.NashvilleHousing

update NashvilleHousing set SoldAsVacant = 
CASE when SoldAsVacant = 'Y' THEN 'YES'
WHEN SoldAsVacant = 'N' THEN 'NO'
ELSE SoldAsVacant 
END

select * from NashvilleHousing


--Remove Duplicates

--------------------------------------------------------------------------------------------------

--Remove Duplicates
WITH RowNumCTE AS(
select *,Row_NUMBER() OVER (PARTITION by ParcelID,PropertyAddress,SaleDate,LegalReference Order by uniqueID)row_num
from PortfolioProject2.dbo.NashvilleHousing --order by ParcelID
)
--select * from RowNumCTE where row_num>1
--Delete from RowNumCTE where row_num>1
select * from RowNumCTE where row_num>1

alter table PortfolioProject2.dbo.NashvilleHousing drop Column OwnerAddress,TaxDistrict,PropertyAddress,SaleDate














































