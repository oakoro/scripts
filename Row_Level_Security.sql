--create table orders
--(
--	orderid int,
--	agent varchar(50),
--	course varchar(50),
--	quantity int
--)
--select * from orders
--drop table orders
--insert into orders
--values(1,'AgentA','AZ-900',5),
--		(2,'AgentB','AZ-104',6),
--		(3,'AgentA','AZ-303',7),
--		(4,'AgentB','AZ-304',8),
--		(5,'AgentA','DP-900',9)

--create user supervisor without login;
--create user agenta without login;
--create user agentb without login;

--grant select on dbo.orders to supervisor;
--grant select on dbo.orders to agenta;
--grant select on dbo.orders to agentb;

--create schema security;

--create function security.securitypredicate(@agent as nvarchar(50))
--	Returns TABLE
--with schemabinding
--as
--	return select 1 as securitypredicate_result
--where @agent = USER_NAME() or USER_NAME() = 'supervisor';

--CREATE SECURITY POLICY FILTER
--ADD filter predicate security.securitypredicate(agent)
--ON dbo.orders
--with (state = ON);

--grant select on security.securitypredicate to supervisor;
--grant select on security.securitypredicate to agenta;
--grant select on security.securitypredicate to agentb;

--exec as user = 'agentb';
--select * from dbo.orders;
--revert;