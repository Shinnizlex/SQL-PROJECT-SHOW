-------Cleaning Data in SQL Queries----------
Select*
From ProjectDatabase.dbo.NashvilleHousing

------Standardize Date Format---------
Select Saledateconverted, Convert(Date,Saledate)
From ProjectDatabase.dbo.NashvilleHousing

Update NashvilleHousing
SET saledate = Convert(Date,Saledate)

Alter TABLE NashvilleHousing
ADD Saledateconverted date;

Update NashvilleHousing
SET saledateconverted = Convert(Date,Saledate)
-------------------------------------------------------------------------
----------Populate Property address data-----------

Select *
From ProjectDatabase.dbo.NashvilleHousing
---Where Propertyaddress IS NULL
Order BY ParcelId


Select a.parceLId, a.PropertyAddress, B.parcelid, B.PropertyAddress, ISNULL (a.PropertyAddress,b.PropertyAddress)
From ProjectDatabase.dbo.NashvilleHousing a
Join ProjectDatabase.dbo.NashvilleHousing b
On a.parcelId = b.parcelID
AND a.[uniqueID ] <> B.[uniqueId ]
where a.PropertyAddress Is null

Update a
Set PropertyAddress = ISNULL (a.PropertyAddress,b.PropertyAddress)
From ProjectDatabase.dbo.NashvilleHousing a
Join ProjectDatabase.dbo.NashvilleHousing b
On a.parcelId = b.parcelID
AND a.[uniqueID ] <> B.[uniqueId ]
where a.PropertyAddress Is null

-----------------------------------------------------------------------------
-------------Breaking out Address into indviual columns (Address, city, State)----------

Select PropertyAddress
From ProjectDatabase.dbo.NashvilleHousing
---Where Propertyaddress IS NULL
---Order BY ParcelId

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress)) as Address


From ProjectDatabase.dbo.NashvilleHousing
---------------------------------------------------------------------------------------------------

Alter TABLE NashvilleHousing
ADD PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

Alter TABLE NashvilleHousing
ADD PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress))

Select*
From ProjectDatabase.dbo.NashvilleHousing


Select OwnerAddress
From ProjectDatabase.dbo.NashvilleHousing

Select
PARSENAME(REPLACE(OwnerAddress, ',','.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',','.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',','.') , 1)
From ProjectDatabase.dbo.NashvilleHousing

Alter TABLE NashvilleHousing
ADD OwnersplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnersplitAddress = PARSENAME(REPLACE(OwnerAddress, ',','.') , 3)

Alter TABLE NashvilleHousing
ADD OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',','.') , 2)

Alter TABLE NashvilleHousing
ADD OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',','.') , 1)

Select *
From ProjectDatabase.dbo.NashvilleHousing



------------------------------------------------------------
--------Change Y and N to Yes and No in ¨sold as vacant ¨field------------

Select Distinct(Soldasvacant), Count(Soldasvacant)
From ProjectDatabase.dbo.NashvilleHousing
Group By Soldasvacant
Order by 2

Select Soldasvacant
, case when SoldAsVacant = 'Y'THEN 'Yes'
        When SoldAsVacant = 'N' Then 'No'
		Else SoldAsVacant
		END 
From ProjectDatabase.dbo.NashvilleHousing

Update ProjectDatabase.dbo.NashvilleHousing
SET SOLDASVACANT = case when SoldAsVacant = 'Y'THEN 'Yes'
        When SoldAsVacant = 'N' Then 'No'
		Else SoldAsVacant
		END 


Select Distinct(Soldasvacant), Count(Soldasvacant)
From ProjectDatabase.dbo.NashvilleHousing
Group By Soldasvacant
Order by 2



-----------------------------------------------------------------------------------------------------
---------------Remove Duplicates-------------
With roWnumCTE AS(
Select *,
     ROW_NUMBER() Over(
	 Partition BY parcelID,
	             PropertyAddress,
				 Saleprice,
				 Saledate,
				 Legalreference
				 ORDER BY
				 UniqueID
				 ) row_num
From ProjectDatabase.dbo.NashvilleHousing
----Order BY ParcelID-------------
)
Select*
From roWnumCTE
where row_num > 1
order by PropertyAddress






------------------------------------------------------
---------------DELETE UNUSED COLUMNS---------------------

Select*
From ProjectDatabase.dbo.NashvilleHousing

ALTER TABLE ProjectDatabase.dbo.NashvilleHousing
DROP COLUMN Owneraddress, taxdistrict, PropertyAddress

ALTER TABLE ProjectDatabase.dbo.NashvilleHousing
DROP COLUMN Saledate
----------------------------------------------------------
------------------ Thanks for see my Proyect------ Whit Love Sebastian R.-----------------------


