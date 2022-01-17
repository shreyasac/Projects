
  -- Cleaning Data in SQL Queries

  SELECT *
  FROM PortfolioProject.dbo.NashvilleHousingData
  ORDER BY 2

  -- Standardising Date format

  Update NashvilleHousingData
  SET SaleDate = Convert(Date,SaleDate)

  -- Alternate way

  ALTER TABLE NashvilleHousingData
  ADD SaleDate2 Date;

  Update NashvilleHousingData
  SET SaleDate2 = CONVERT(Date,SaleDate)

  -- Populate Property Address data

  SELECT ParcelID, PropertyAddress
  FROM PortfolioProject.dbo.NashvilleHousingData
  WHERE PropertyAddress IS NULL

  SELECT t1.ParcelID, t1.PropertyAddress, t2.ParcelID, t2.PropertyAddress, ISNULL(t1.PropertyAddress, t2.PropertyAddress)
  FROM NashvilleHousingData t1
  JOIN NashvilleHousingData t2
  ON t1.ParcelID = t2.ParcelID
  AND t1.UniqueID != t2.UniqueID
  WHERE t1.PropertyAddress IS NULL
  ORDER BY t1.ParcelID

  UPDATE t1
  SET PropertyAddress = ISNULL(t1.PropertyAddress, t2.PropertyAddress)
  FROM NashvilleHousingData t1
  JOIN NashvilleHousingData t2
  ON t1.ParcelID = t2.ParcelID
  AND t1.UniqueID != t2.UniqueID
  WHERE t1.PropertyAddress IS NULL

  -- Breaking out address into different columns (street, city, state)	

  SELECT PropertyAddress
  FROM PortfolioProject.dbo.NashvilleHousingData

  SELECT SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address,
  SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) AS Address
  FROM PortfolioProject.dbo.NashvilleHousingData

  ALTER TABLE NashvilleHousingData
  ADD AddressStreet nvarchar(255);

  Update NashvilleHousingData
  SET AddressStreet = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

  ALTER TABLE NashvilleHousingData
  ADD AddressCity nvarchar(255);

  Update NashvilleHousingData
  SET AddressCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))


  -- Breaking out OwnerAddress column into street, city, state address.

  SELECT OwnerAddress
  FROM PortfolioProject.dbo.NashvilleHousingData

  SELECT PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) AS OwnerStreet, 
  PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) AS OwnerCity,
  PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) AS OwnerState
  FROM PortfolioProject.dbo.NashvilleHousingData

  ALTER TABLE NashvilleHousingData
  ADD OwnerStreet nvarchar(255);
  
  Update NashvilleHousingData
  SET OwnerStreet = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

  ALTER TABLE NashvilleHousingData
  ADD OwnerCity nvarchar(255);

  Update NashvilleHousingData
  SET OwnerCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

  ALTER TABLE NashvilleHousingData
  ADD OwnerState nvarchar(255);

  Update NashvilleHousingData
  SET OwnerState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)


  -- Looking at categorical data in SoldAsVacant column

  SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
  FROM PortfolioProject.dbo.NashvilleHousingData
  GROUP BY SoldAsVacant

  -- Changing 'N' to 'No' and 'Y' to 'Yes' in SoldAsVacant column

  SELECT SoldAsVacant,
  CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   Else SoldAsVacant
	   END
  FROM PortfolioProject.dbo.NashvilleHousingData


  UPDATE NashvilleHousingData
  SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
						  When SoldAsVacant = 'N' THEN 'No'
						  Else SoldAsVacant
						  END
  FROM PortfolioProject.dbo.NashvilleHousingData

  -- Checking for duplicates

  SELECT UniqueID, COUNT(UniqueID)
  FROM PortfolioProject.dbo.NashvilleHousingData
  GROUP BY UniqueID
  HAVING COUNT(UniqueID) > 1

  -- Dropping extra/unused columns

  SELECT *
  FROM PortfolioProject.dbo.NashvilleHousingData

  ALTER TABLE NashvilleHousingData
  DROP COLUMN PropertyAddress, SaleDate, OwnerAddress
 