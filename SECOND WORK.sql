select *
from housing

-- Standardize Date Format


Select saleDate, CONVERT(Date,saledate)
From housing

update housing
set SaleDate = CONVERT(Date,saledate)

ALTER TABLE housing
ADD SaleDateConverted DATE

update housing
set SaleDateConverted = CONVERT(Date,saledate)


Select saleDateConverted
From housing


-- Populate Property Address data
Select PropertyAddress 
From housing
where PropertyAddress is null

Select * 
From housing
--where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.propertyaddress,b.PropertyAddress) 
From housing a
join housing b
    on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

UPDATE a
SET PropertyAddress =  ISNULL(a.propertyaddress,b.PropertyAddress) 
From housing a
join housing b
    on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

-- Breaking out Address into Individual Columns (Address, City, State)
Select PropertyAddress 
From housing
--where PropertyAddress is null


SELECT
SUBSTRING(Propertyaddress,1, CHARINDEX(',', PropertyAddress, -1)) as Address
SUBSTRING(Propertyaddress,CHARINDEX(',', Propertyaddress) +1, LEN(Propertyaddress)) as Address
FROM housing

ALTER TABLE housing
ADD propertsplitaddress Nvarchar(300)

update housing
set propertsplitaddress = SUBSTRING(Propertyaddress,1, CHARINDEX(',', Propertyaddress, -1))

ALTER TABLE housing
ADD propertsplitcity  Nvarchar(300)

update housing
set propertsplitcity = SUBSTRING(Propertyaddress,CHARINDEX(',', Propertyaddress) +1, LEN(Propertyaddress))


SELECT *
From housing

SELECT OwnerAddress
From housing

SELECT 
PARSENAME(REPLACE(owneraddress, ',', '.') ,3)
,PARSENAME(REPLACE(owneraddress, ',', '.') ,2)
,PARSENAME(REPLACE(owneraddress, ',', '.') ,1)
From housing


ALTER TABLE housing
ADD Ownersplitaddress Nvarchar(300)

update housing
set Ownersplitaddress = PARSENAME(REPLACE(owneraddress, ',', '.') ,3)


ALTER TABLE housing
ADD Ownersplitcity  Nvarchar(300)

update housing
set Ownersplitcity  = PARSENAME(REPLACE(owneraddress, ',', '.') ,2)


ALTER TABLE housing
ADD Ownersplitstate  Nvarchar(300)

update housing
set Ownersplitstate  = PARSENAME(REPLACE(owneraddress, ',', '.') ,1)

SELECT *
From housing

-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From Housing
Group by SoldAsVacant
order by 2

Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
     When SoldAsVacant = 'N' THEN 'No'
     ELSE SoldAsVacant
     END
From Housing


Update Housing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
     When SoldAsVacant = 'N' THEN 'No'
     ELSE SoldAsVacant
     END


	 -- Remove Duplicates

	 WITH RowNumCTE AS(
Select *,
  ROW_NUMBER() OVER (
  PARTITION BY ParcelID,
         PropertyAddress,
         SalePrice,
         SaleDate,
         LegalReference
         ORDER BY
          UniqueID
          ) row_num
From Housing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress


-- Delete Unused Columns



Select *
From Housing


ALTER TABLE Housing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate