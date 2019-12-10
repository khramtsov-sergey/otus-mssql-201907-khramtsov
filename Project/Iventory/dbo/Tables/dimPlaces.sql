CREATE TABLE [dbo].[dimPlaces]
(
	[PlaceId] [int] PRIMARY KEY,
			CONSTRAINT FK_dimPlaces_Items 
			FOREIGN KEY (PlaceID) REFERENCES dbo.[dimPlaces] ([PlaceId]),
	[EmployeeID] [int] NULL,
	[OfficeID] [smallint] NULL,
	[FirstName] [nvarchar](128) NULL,
	[LastName] [nvarchar](128) NULL,
	[Email] [nvarchar](128) NULL,
	[CompanyID] [smallint]  NULL,
	[OfficeName] [nvarchar](32) NULL,
	[CompanyName] [nvarchar](128) NULL,
)
