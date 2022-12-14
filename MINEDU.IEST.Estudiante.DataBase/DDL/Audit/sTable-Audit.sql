-- use db_regia_5

-- go



CREATE TABLE [Audit].[AuditLog] (
    [AuditLogId] INT            IDENTITY (1, 1) NOT NULL,
    [Time]       DATETIME       NOT NULL,
    [UserName]   NVARCHAR (256) NOT NULL,
    [Service]    VARCHAR (MAX)  NOT NULL,
    [Action]     VARCHAR (MAX)  NOT NULL,
    [Duration]   BIGINT         NOT NULL,
    [IPAddress]  VARCHAR (250)  NOT NULL,
    [Browser]    VARCHAR (MAX)  NOT NULL,
    [Request]    VARCHAR (MAX)  NOT NULL,
    [Response]   VARCHAR (MAX)  NOT NULL,
    [Error]      VARCHAR (MAX)  NOT NULL,
    CONSTRAINT [PK_AuditLog] PRIMARY KEY CLUSTERED ([AuditLogId] ASC)
);

go


CREATE TABLE [Audit].[Log] (
   [Id] INT IDENTITY(1,1) NOT NULL,
   [Message] nvarchar(max) NULL,
   [MessageTemplate] nvarchar(max) NULL,
   [Level] nvarchar(128) NULL,
   [TimeStamp] datetime NOT NULL,
   [Exception] nvarchar(max) NULL,
   [Properties] nvarchar(max) NULL

   CONSTRAINT [PK_Logs] PRIMARY KEY CLUSTERED ([Id] ASC)
);

