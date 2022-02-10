/*

Cleaning Data in SQL Queries

*/


Select *
From friaproject.dbo.NashvilleBostadsmarknad

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format


Select saleDate , CONVERT(Date,SaleDate)
From friaproject.dbo.NashvilleBostadsmarknad


Update NashvilleBostadsmarknad
SET SaleDate = CONVERT(Date,SaleDate)


 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select *
From friaproject.dbo.NashvilleBostadsmarknad
--Where PropertyAddress is null
order by ParcelID



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From friaproject.dbo.NashvilleBostadsmarknad a
JOIN friaproject.dbo.NashvilleBostadsmarknad b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From friaproject.dbo.NashvilleBostadsmarknad a
JOIN friaproject.dbo.NashvilleBostadsmarknad b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null




--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From friaproject.dbo.NashvilleBostadsmarknad
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From friaproject.dbo.NashvilleBostadsmarknad


ALTER TABLE NashvilleBostadsmarknad
Add PropertySplitAddress Nvarchar(255);

Update NashvilleBostadsmarknad
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE NashvilleBostadsmarknad
Add PropertySplitCity Nvarchar(255);

Update NashvilleBostadsmarknad
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))




Select *
From friaproject.dbo.NashvilleBostadsmarknad





Select OwnerAddress
From friaproject.dbo.NashvilleBostadsmarknad


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From friaproject.dbo.NashvilleBostadsmarknad



ALTER TABLE NashvilleBostadsmarknad
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleBostadsmarknad
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE NashvilleBostadsmarknad
Add OwnerSplitCity Nvarchar(255);

Update NashvilleBostadsmarknad
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE NashvilleBostadsmarknad
Add OwnerSplitState Nvarchar(255);

Update NashvilleBostadsmarknad
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From friaproject.dbo.NashvilleBostadsmarknad




--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From friaproject.dbo.NashvilleBostadsmarknad
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From friaproject.dbo.NashvilleBostadsmarknad


Update NashvilleBostadsmarknad
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END






-----------------------------------------------------------------------------------------------------------------------------------------------------------

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

From friaproject.dbo.NashvilleBostadsmarknad
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From friaproject.dbo.NashvilleBostadsmarknad




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From friaproject.dbo.NashvilleBostadsmarknad


ALTER TABLE friaproject.dbo.NashvilleBostadsmarknad
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate















-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------

--- Importing Data using OPENROWSET and BULK INSERT	

--  More advanced and looks cooler, but have to configure server appropriately to do correctly
--  Wanted to provide this in case you wanted to try it


--sp_configure 'show advanced options', 1;
--RECONFIGURE;
--GO
--sp_configure 'Ad Hoc Distributed Queries', 1;
--RECONFIGURE;
--GO


--USE friaproject 

--GO 

--EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.Jet.OLEDB.4.0', N'AllowInProcess', 1 

--GO 

--EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.Jet.OLEDB.4.0', N'DynamicParameters', 1 

--GO 


---- Using BULK INSERT

--USE friaproject;
--GO
--BULK INSERT nashvilleHousing FROM 'C:\Temp\SQL Server Management Studio\Cleaning-Housing-Data.csv'
--   WITH (
--      FIELDTERMINATOR = ',',
--      ROWTERMINATOR = '\n'
--);
--GO


---- Using OPENROWSET
--USE friaproject;
--GO
--SELECT * INTO NashvilleBostadsmarknad
--FROM OPENROWSET('Microsoft.Jet.OLEDB.4.0',
--    'Excel 12.0; Database=C:\Users\alexf\OneDrive\Documents\SQL Server Management Studio\Cleaning-Housing-Data.csv', [Sheet1$]);
--GO

















