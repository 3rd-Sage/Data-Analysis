-- Cleaning data Project

SELECT UniqueID, ParcelID, Saledate, SalePrice, SoldAsVacant, OwnerName, LandUse, LandValue, BuildingValue, TotalValue, YearBuilt, PropertySplitAddress, OwnerSplitAddress, PropertysplitCity, OwnerSplitCity
FROM Projects..Nashville_Housing

-- Set date to normal format
-- when a date looks 2015-11-04 00.00.00.00
select SaleDate, CONVERT(Date, SaleDate)
from Projects..Nashville_Housing

UPDATE Projects..Nashville_Housing
SET SaleDate = CONVERT(Date, SaleDate)

-- Replace property Address data

SELECT *
FROM Projects..Nashville_Housing
-- WHERE PropertyAddress is NULL
ORDER BY ParcelID

-- Populating PropertyAddress when null if they share the same ParcelID
SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL (a.PropertyAddress,b.PropertyAddress)
FROM Projects..Nashville_Housing a
JOIN Projects..Nashville_Housing b
    on a.ParcelID = b.ParcelID
    AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress is null;
-- where ParcelID is the same, and the uniqueid is different then take the PropertyAddress and add to the null column
UPDATE a
SET PropertyAddress = ISNULL (a.PropertyAddress,b.PropertyAddress)
FROM Projects..Nashville_Housing a
JOIN Projects..Nashville_Housing b
    on a.ParcelID = b.ParcelID
    AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress is null

-- Breaking out address into different column

select OwnerAddress
FROM Projects..Nashville_Housing

-- search for a particular value to change
SELECT 
SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) Address,
SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress)) State

FROM Projects..Nashville_Housing ;

ALTER TABLE Nashville_Housing
    ADD PropertySplitAddress NVARCHAR(225)
GO

ALTER TABLE Nashville_Housing
    ADD PropertySplitCity NVARCHAR(255)
GO;

UPDATE Projects..Nashville_Housing
SET PropertySplitAddress = SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

UPDATE Projects..Nashville_Housing
SET PropertySplitCity = SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress))

-- An easier way to splict a column

SELECT SoldAsVacant
FROM Projects..Nashville_Housing
-- Using Parsename to make splitting columns Easier
SELECT
PARSENAME(Replace(OwnerAddress, ',' , '.'), 3) as Address,
PARSENAME(Replace(OwnerAddress, ',' , '.'), 2) as Address,
PARSENAME(Replace(OwnerAddress, ',' , '.'), 1) as Address
FROM Projects..Nashville_Housing

ALTER TABLE Nashville_Housing
 ADD OwnerSplitAddress NVARCHAR(255)
GO

ALTER TABLE Nashville_Housing
 ADD OwnerSplitCity VARCHAR(255)
GO

ALTER TABLE Nashville_Housing
 ADD OwnerSplitState VARCHAR(255)
GO

UPDATE Projects..Nashville_Housing
set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress, ',' , '.'), 3)

UPDATE Projects..Nashville_Housing
set OwnerSplitCity = PARSENAME(Replace(OwnerAddress, ',' , '.'), 2)

UPDATE Projects..Nashville_Housing
set OwnerSplitState = PARSENAME(Replace(OwnerAddress, ',' , '.'), 1)

-- change values in a cell to a new value 

UPDATE Nashville_Housing
SET SoldAsVacant = 'Yes' 
WHERE SoldAsVacant = 'Y'

UPDATE Nashville_Housing
SET SoldAsVacant = 'No'
WHERE SoldAsVacant = 'N'

-- Using a case statement to change values

SELECT SoldAsVacant,
CASE when SoldAsVacant = 'Y' THEN 'Yes' 
     when SoldAsVacant = 'N' THEN 'No'
     ELSE SoldAsVacant
END
FROM Projects..Nashville_Housing

-- after the case statement then update the table but i used update staright away

-- Removing Duplicates
-- Using a cte 
WITH RowNUMCTE as (
SELECT *,
    ROW_NUMBER() OVER (
        PARTITION BY ParcelID,
                     PropertyAddress,
                     SalePrice,
                     SaleDate,
                     LegalReference
                     ORDER BY UniqueID 
                     ) row_num

FROM Projects..Nashville_Housing
-- order by ParcelID
)

SELECT * FROM RowNUMCTE
WHERE row_num > 1
-- ORDER BY PropertyAddress


-- dropping columns
ALTER TABLE Nashville_Housing
DROP COLUMN [columnName]

-- FINAL CORRECTIONS
UPDATE Nashville_Housing
SET LandUse = 'VACANT RESIDENTIAL LAND'
WHERE LandUse = 'VACANT RESIENTIAL LAND'