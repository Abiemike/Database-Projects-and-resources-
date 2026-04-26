--Create a trigger on [Security_Logins] table to track password changes.

--Password before modification must be stored in the new table with timestamp.

USE [JOB_PORTAL_DB]

GO
 
--Init record

update [dbo].[Security_Logins] set Password = '0' WHERE Login = 'MarlonPeck'

GO
 
/****** Object:  Table [dbo].[Security_Passwords]    Script Date: 6/12/2020 10:07:39 PM ******/

SET ANSI_NULLS ON

GO
 
SET QUOTED_IDENTIFIER ON

GO
 
--Create a table to save old password and date of change

CREATE TABLE [dbo].[Security_Passwords](

	[Id] [uniqueidentifier] NOT NULL,

	[LoginId] [uniqueidentifier] NULL,

	[Password] [varchar](100) NULL,

	[Audit_Date] [datetime] NULL,

CONSTRAINT [PK_Security_Passwords] PRIMARY KEY CLUSTERED 

(

	[Id] ASC

)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

) ON [PRIMARY]

GO
 
ALTER TABLE [dbo].[Security_Passwords] ADD  CONSTRAINT [DF_Security_Passwords_Id]  DEFAULT (newid()) FOR [Id]

GO
 
ALTER TABLE [dbo].[Security_Passwords] ADD  CONSTRAINT [DF_Security_Passwords_Audit_Date]  DEFAULT (getdate()) FOR [Audit_Date]

GO
 
 
/****** Object:  Trigger [dbo].[TR_UPDATE_PasswordChanges]    Script Date: 6/12/2020 10:08:43 PM ******/

SET ANSI_NULLS ON

GO
 
SET QUOTED_IDENTIFIER ON

GO

--Triger to log previous password before new one is saved.

--If New Password = Old Password log will not be updated.

CREATE OR ALTER TRIGGER [dbo].[TR_UPDATE_PasswordChanges]

   ON  [dbo].[Security_Logins]

   AFTER UPDATE

AS 

BEGIN

	SET NOCOUNT ON;

	--we want to reject password = 2

	if exists(select * from inserted where password = '2')

	begin

		raiserror('Cannot save',1,16)

		--TRY TO COMMENT 'ROLLBACK' OR 'RETURN' lines and see difference

		--RETURN

		ROLLBACK

	end
 
	insert into [dbo].[Security_Passwords] ([LoginId],[Password])

	select OLD.Id, OLD.[Password] from inserted AS NEW

	inner join deleted AS OLD on NEW.id = OLD.id

	WHERE NEW.Password <> OLD.Password

END

GO
 
ALTER TABLE [dbo].[Security_Logins] ENABLE TRIGGER [TR_UPDATE_PasswordChanges]

GO
 
delete from [Security_Passwords]

GO
 
--TEST TRIGGER -- Password change to 1 -> 2 -> 3 -> 4 -> 5

set nocount on;

update [dbo].[Security_Logins] set Password = '1' WHERE Login = 'MarlonPeck'

--select * from [dbo].[Security_Passwords] order by audit_date desc

GO

waitfor delay '00:00:01'

update [dbo].[Security_Logins] set Password = '2' WHERE Login = 'MarlonPeck'

--select * from [dbo].[Security_Passwords] order by audit_date desc

GO

waitfor delay '00:00:05'

update [dbo].[Security_Logins] set Password = '3' WHERE Login = 'MarlonPeck'

--select * from [dbo].[Security_Passwords] order by audit_date desc

GO

waitfor delay '00:00:01'

update [dbo].[Security_Logins] set Password = '4', Is_Locked = 0 WHERE Login = 'MarlonPeck'

--select * from [dbo].[Security_Passwords] order by audit_date desc

GO

--This change will not be inserted into the log

waitfor delay '00:00:01'

update [dbo].[Security_Logins] set Is_Locked = 1 WHERE Login = 'MarlonPeck'

--select * from [dbo].[Security_Passwords] order by audit_date desc

GO

--This change will be inserted into the log

waitfor delay '00:00:01'

update [dbo].[Security_Logins] set Password = '5' WHERE Login = 'MarlonPeck'

select * from [dbo].[Security_Passwords] order by audit_date desc

select * from [dbo].[Security_Logins] where Login = 'MarlonPeck'

GO
 
DROP TRIGGER TR_UPDATE_PasswordChanges

DROP TABLE [dbo].[Security_Passwords]

GO

 
--Create a trigger on [Security_Logins] table to track password changes.

--Password before modification must be stored in the new table with timestamp.

USE [JOB_PORTAL_DB]

GO
 
--Init record

update [dbo].[Security_Logins] set Password = '0' WHERE Login = 'MarlonPeck'

GO
 
/****** Object:  Table [dbo].[Security_Passwords]    Script Date: 6/12/2020 10:07:39 PM ******/

SET ANSI_NULLS ON

GO
 
SET QUOTED_IDENTIFIER ON

GO
 
--Create a table to save old password and date of change

CREATE TABLE [dbo].[Security_Passwords](

	[Id] [uniqueidentifier] NOT NULL,

	[LoginId] [uniqueidentifier] NULL,

	[Password] [varchar](100) NULL,

	[Audit_Date] [datetime] NULL,

CONSTRAINT [PK_Security_Passwords] PRIMARY KEY CLUSTERED 

(

	[Id] ASC

)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

) ON [PRIMARY]

GO
 
ALTER TABLE [dbo].[Security_Passwords] ADD  CONSTRAINT [DF_Security_Passwords_Id]  DEFAULT (newid()) FOR [Id]

GO
 
ALTER TABLE [dbo].[Security_Passwords] ADD  CONSTRAINT [DF_Security_Passwords_Audit_Date]  DEFAULT (getdate()) FOR [Audit_Date]

GO
 
 
/****** Object:  Trigger [dbo].[TR_UPDATE_PasswordChanges]    Script Date: 6/12/2020 10:08:43 PM ******/

SET ANSI_NULLS ON

GO
 
SET QUOTED_IDENTIFIER ON

GO

--Triger to log previous password before new one is saved.

--If New Password = Old Password log will not be updated.

CREATE OR ALTER TRIGGER [dbo].[TR_UPDATE_PasswordChanges]

   ON  [dbo].[Security_Logins]

   AFTER UPDATE

AS 

BEGIN

	SET NOCOUNT ON;

	--we want to reject password = 2

	if exists(select * from inserted where password = '2')

	begin

		raiserror('Cannot save',1,16)

		--TRY TO COMMENT 'ROLLBACK' OR 'RETURN' lines and see difference

		--RETURN

		ROLLBACK

	end
 
	insert into [dbo].[Security_Passwords] ([LoginId],[Password])

	select OLD.Id, OLD.[Password] from inserted AS NEW

	inner join deleted AS OLD on NEW.id = OLD.id

	WHERE NEW.Password <> OLD.Password

END

GO
 
ALTER TABLE [dbo].[Security_Logins] ENABLE TRIGGER [TR_UPDATE_PasswordChanges]

GO
 
delete from [Security_Passwords]

GO
 
--TEST TRIGGER -- Password change to 1 -> 2 -> 3 -> 4 -> 5

set nocount on;

update [dbo].[Security_Logins] set Password = '1' WHERE Login = 'MarlonPeck'

--select * from [dbo].[Security_Passwords] order by audit_date desc

GO

waitfor delay '00:00:01'

update [dbo].[Security_Logins] set Password = '2' WHERE Login = 'MarlonPeck'

--select * from [dbo].[Security_Passwords] order by audit_date desc

GO

waitfor delay '00:00:05'

update [dbo].[Security_Logins] set Password = '3' WHERE Login = 'MarlonPeck'

--select * from [dbo].[Security_Passwords] order by audit_date desc

GO

waitfor delay '00:00:01'

update [dbo].[Security_Logins] set Password = '4', Is_Locked = 0 WHERE Login = 'MarlonPeck'

--select * from [dbo].[Security_Passwords] order by audit_date desc

GO

--This change will not be inserted into the log

waitfor delay '00:00:01'

update [dbo].[Security_Logins] set Is_Locked = 1 WHERE Login = 'MarlonPeck'

--select * from [dbo].[Security_Passwords] order by audit_date desc

GO

--This change will be inserted into the log

waitfor delay '00:00:01'

update [dbo].[Security_Logins] set Password = '5' WHERE Login = 'MarlonPeck'

select * from [dbo].[Security_Passwords] order by audit_date desc

select * from [dbo].[Security_Logins] where Login = 'MarlonPeck'

GO
 
DROP TRIGGER TR_UPDATE_PasswordChanges

DROP TABLE [dbo].[Security_Passwords]

GO

 