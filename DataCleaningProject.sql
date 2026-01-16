/*

Cleaning Data in SQL Queries

*/

Select *
From PortfolioProjects..BostonHousing

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

Select saleDate, CONVERT(Date,SaleDate) as SaleDate
From PortfolioProjects.dbo.BostonHousing




ALTER TABLE dbo.BostonHousing
ADD SaleDateConverted DATE;

UPDATE dbo.BostonHousing
SET SaleDateConverted = CONVERT(DATE, SaleDate);

--------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select *
From PortfolioProjects.dbo.BostonHousing
--Where PropertyAddress is null
order by ParcelID

Select *
From PortfolioProjects.dbo.BostonHousing


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProjects.dbo.BostonHousing a
JOIN PortfolioProjects.dbo.BostonHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProjects.dbo.BostonHousing a
JOIN PortfolioProjects.dbo.BostonHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From PortfolioProjects.dbo.BostonHousing
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From PortfolioProjects.dbo.BostonHousing


ALTER TABLE BostonHousing
Add PropertySplitAddress Nvarchar(255);

Update BostonHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE BostonHousing
Add PropertySplitCity Nvarchar(255);

Update BostonHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))




Select *
From PortfolioProjects.dbo.BostonHousing





Select OwnerAddress
From PortfolioProjects.dbo.BostonHousing


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From PortfolioProjects.dbo.BostonHousing


ALTER TABLE BostonHousing
Add OwnerSplitAddress Nvarchar(255);

Update BostonHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE BostonHousing
Add OwnerSplitCity Nvarchar(255);

Update BostonHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE BostonHousing
Add OwnerSplitState Nvarchar(255);

Update BostonHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From PortfolioProjects.dbo.BostonHousing




--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProjects.dbo.BostonHousing
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From PortfolioProjects.dbo.BostonHousing


Update BostonHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END


Select SoldAsVacant
, CASE When SoldAsVacant = 'Yes' THEN 'Vacant'
	   When SoldAsVacant = 'No' THEN 'Sold'
	   ELSE SoldAsVacant
	   END
From PortfolioProjects.dbo.BostonHousing





-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

--See all the Duplicate

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

From PortfolioProjects.dbo.BostonHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress


--DELETE all the Duplicate

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

From PortfolioProjects.dbo.BostonHousing
--order by ParcelID
)
--Select *
DELETE
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress


Select *
From PortfolioProjects.dbo.BostonHousing




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From PortfolioProjects.dbo.BostonHousing


ALTER TABLE PortfolioProjects.dbo.BostonHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate