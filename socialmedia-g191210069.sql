--
-- PostgreSQL database dump
--

-- Dumped from database version 14.0
-- Dumped by pg_dump version 14.0

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: addpost(integer, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.addpost(postid integer, description character varying, image character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN

INSERT INTO public."Post"("User_id","postDescription","postImageLink","postedTime") values (postID,description,image,CURRENT_DATE);

end
$$;


ALTER FUNCTION public.addpost(postid integer, description character varying, image character varying) OWNER TO postgres;

--
-- Name: adduser(character varying, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.adduser(nameinput character varying, surnameinput character varying, emailinput character varying, usernameinput character varying, passwordinput character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
INSERT INTO public."User"("name","surname","email","username","password") values (nameInput,surnameInput,emailInput,usernameInput,passwordInput);
end
$$;


ALTER FUNCTION public.adduser(nameinput character varying, surnameinput character varying, emailinput character varying, usernameinput character varying, passwordinput character varying) OWNER TO postgres;

--
-- Name: createnumberoffollowertable(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.createnumberoffollowertable() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

INSERT INTO public."NumberOfFollower"("userID","numberOfFollower") values (new."userID",0);
return new;

end
$$;


ALTER FUNCTION public.createnumberoffollowertable() OWNER TO postgres;

--
-- Name: deletenumberoffollowerrow(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.deletenumberoffollowerrow() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

delete from "NumberOfFollower" where "userID"=new."userID";
return new;

end
$$;


ALTER FUNCTION public.deletenumberoffollowerrow() OWNER TO postgres;

--
-- Name: deleteuser(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.deleteuser(deletinguserid integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
delete from public."User" where "userID"=deletingUserID;
end
$$;


ALTER FUNCTION public.deleteuser(deletinguserid integer) OWNER TO postgres;

--
-- Name: followuser(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.followuser(userid integer, followingid integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN

INSERT INTO public."Following"("ownerID","followedID") values (userID,followingID);

end
$$;


ALTER FUNCTION public.followuser(userid integer, followingid integer) OWNER TO postgres;

--
-- Name: increasefollowernumber(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.increasefollowernumber() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

update "NumberOfFollower" set "numberOfFollower"= "numberOfFollower" + 1 where "userID"=new."followedID";
return new;

end
$$;


ALTER FUNCTION public.increasefollowernumber() OWNER TO postgres;

--
-- Name: posttrigger(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.posttrigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

INSERT INTO public."UserPost"("userPostID") values (new."Post_id");
return new;
end
$$;


ALTER FUNCTION public.posttrigger() OWNER TO postgres;

--
-- Name: searchuser(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.searchuser(searchuserid integer) RETURNS TABLE(userid integer, usernameuniqe character varying, username character varying, usersurname character varying, email character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN

return query select "User"."userID","User"."username","User"."name","User"."surname","User"."email" from public."User" where "User"."userID" = searchUserID;

end
$$;


ALTER FUNCTION public.searchuser(searchuserid integer) OWNER TO postgres;

--
-- Name: updateuser(integer, character varying, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.updateuser(updateuseridinput integer, nameinput character varying, surnameinput character varying, emailinput character varying, usernameinput character varying, passwordinput character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
UPDATE "User" set "name"=nameInput,"surname"=surnameInput ,"email"=emailInput ,"username"=usernameInput,"password"=passwordInput where "userID"=updateUserIDInput;
end
$$;


ALTER FUNCTION public.updateuser(updateuseridinput integer, nameinput character varying, surnameinput character varying, emailinput character varying, usernameinput character varying, passwordinput character varying) OWNER TO postgres;

--
-- Name: usercount(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.usercount() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

update "NumberOfUser" set "numberOfUser"= "numberOfUser" + 1;
return new;

end
$$;


ALTER FUNCTION public.usercount() OWNER TO postgres;

--
-- Name: usercountdown(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.usercountdown() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

update "NumberOfUser" set "numberOfUser"= "numberOfUser" - 1;
return new;

end
$$;


ALTER FUNCTION public.usercountdown() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: BlockUser; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."BlockUser" (
    "blockID" integer NOT NULL,
    "ownerID" integer NOT NULL,
    "blockedTime" date NOT NULL
);


ALTER TABLE public."BlockUser" OWNER TO postgres;

--
-- Name: BlockUser_blockID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."BlockUser" ALTER COLUMN "blockID" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."BlockUser_blockID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: Chat; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Chat" (
    "chatID" integer NOT NULL,
    "userID" integer NOT NULL,
    "receiverID" integer NOT NULL
);


ALTER TABLE public."Chat" OWNER TO postgres;

--
-- Name: Chat_chatID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."Chat" ALTER COLUMN "chatID" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."Chat_chatID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: Close Friends; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Close Friends" (
    "ownerID" integer NOT NULL,
    "friendsID" integer NOT NULL
);


ALTER TABLE public."Close Friends" OWNER TO postgres;

--
-- Name: Comment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Comment" (
    "postComment" character varying NOT NULL,
    "commentID" integer NOT NULL,
    "commentedTime" date NOT NULL,
    "Post_id" integer NOT NULL,
    "User_id" integer NOT NULL
);


ALTER TABLE public."Comment" OWNER TO postgres;

--
-- Name: CommentLike; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."CommentLike" (
    "commentLikeID" integer NOT NULL,
    "commentID" integer NOT NULL,
    "likedUserID" integer NOT NULL
);


ALTER TABLE public."CommentLike" OWNER TO postgres;

--
-- Name: CommentLike_commentLikeID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."CommentLike" ALTER COLUMN "commentLikeID" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."CommentLike_commentLikeID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: Comment_commentID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."Comment" ALTER COLUMN "commentID" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."Comment_commentID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: Following; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Following" (
    "ownerID" integer NOT NULL,
    "followedID" integer NOT NULL
);


ALTER TABLE public."Following" OWNER TO postgres;

--
-- Name: Like; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Like" (
    "likeID" integer NOT NULL,
    "postID" integer NOT NULL,
    "userID" integer NOT NULL,
    "likedTime" date NOT NULL
);


ALTER TABLE public."Like" OWNER TO postgres;

--
-- Name: Like_likeID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."Like" ALTER COLUMN "likeID" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."Like_likeID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: Message; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Message" (
    "messageID" integer NOT NULL,
    "messageText" integer NOT NULL,
    "sentTime" date NOT NULL,
    "ownerID" integer NOT NULL,
    "Chat_id" integer NOT NULL,
    "receiverID" integer NOT NULL
);


ALTER TABLE public."Message" OWNER TO postgres;

--
-- Name: Message_messageID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."Message" ALTER COLUMN "messageID" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."Message_messageID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: NumberOfFollower; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."NumberOfFollower" (
    "userID" integer NOT NULL,
    "numberOfFollower" integer DEFAULT 0 NOT NULL
);


ALTER TABLE public."NumberOfFollower" OWNER TO postgres;

--
-- Name: NumberOfUser; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."NumberOfUser" (
    "numberOfUser" integer NOT NULL
);


ALTER TABLE public."NumberOfUser" OWNER TO postgres;

--
-- Name: Post; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Post" (
    "postDescription" character varying NOT NULL,
    "postImageLink" character varying NOT NULL,
    "postID" integer NOT NULL,
    "postedTime" timestamp with time zone NOT NULL,
    "User_id" integer NOT NULL
);


ALTER TABLE public."Post" OWNER TO postgres;

--
-- Name: Post_Post_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."Post" ALTER COLUMN "postID" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."Post_Post_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: Story; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Story" (
    "storyID" integer NOT NULL,
    "imageLink" integer NOT NULL,
    deadline time with time zone NOT NULL
);


ALTER TABLE public."Story" OWNER TO postgres;

--
-- Name: Story_storyID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."Story" ALTER COLUMN "storyID" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."Story_storyID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: User; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."User" (
    "userID" integer NOT NULL,
    username character varying NOT NULL,
    name character varying NOT NULL,
    surname character varying NOT NULL,
    email character varying NOT NULL,
    password character varying NOT NULL
);


ALTER TABLE public."User" OWNER TO postgres;

--
-- Name: UserPost; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."UserPost" (
    "userPostID" integer NOT NULL,
    "userpostIdentityID" integer NOT NULL,
    "numberOfUserPost" integer NOT NULL
);


ALTER TABLE public."UserPost" OWNER TO postgres;

--
-- Name: UserPost_userpostIdentityID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."UserPost" ALTER COLUMN "userpostIdentityID" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."UserPost_userpostIdentityID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: UserStory; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."UserStory" (
    "userStoryID" integer NOT NULL,
    "userStoryIdentityID" integer NOT NULL
);


ALTER TABLE public."UserStory" OWNER TO postgres;

--
-- Name: UserStory_userStoryID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."UserStory" ALTER COLUMN "userStoryID" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."UserStory_userStoryID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: UserStory_userStoryIdentityID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."UserStory" ALTER COLUMN "userStoryIdentityID" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."UserStory_userStoryIdentityID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: User_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."User" ALTER COLUMN "userID" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."User_user_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Data for Name: BlockUser; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: Chat; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: Close Friends; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: Comment; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: CommentLike; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: Following; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Following" VALUES
	(1, 13);


--
-- Data for Name: Like; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: Message; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: NumberOfFollower; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."NumberOfFollower" VALUES
	(1, 0),
	(3, 0),
	(4, 0),
	(5, 0),
	(9, 0),
	(11, 0),
	(12, 0),
	(16, 0),
	(13, 1);


--
-- Data for Name: NumberOfUser; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."NumberOfUser" VALUES
	(10);


--
-- Data for Name: Post; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: Story; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: User; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."User" OVERRIDING SYSTEM VALUE VALUES
	(1, 'ipoudon', 'm furkan', 'balek', 'furkanbalek@gmail.com', '123456'),
	(3, 'ipoudon2', 'furkan', 'balek', 'furkanbalek@gmail.com', '123456'),
	(4, 'asdfasd', 'furkan', 'balek', 'furkanbalek@gmail.com', '123456'),
	(5, 'fasfbsafbs', 'furkan', 'balek', 'furkanbalek@gmail.com', '123456'),
	(9, 'asbsasdvsdb', 'furkan', 'balek', 'furkanbalek@gmail.com', '123456'),
	(12, 'ilkdeneme', 'merhaba', 'bu', 'ilkdeneme@gmail.com', 'ilkdeneme123456'),
	(13, 'rihashus', 'hasan', 'huseyin', 'hasanhuseyin@gmail.com', 'hasan342'),
	(16, 'muratbas', 'murat', 'bas', 'muratbas@gmail.com', 'murat123321'),
	(11, 'kazimkarabekiroffical', 'kazim', 'karabekir', 'kazimkarabekir@gmail.com', 'kazim123321');


--
-- Data for Name: UserPost; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: UserStory; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Name: BlockUser_blockID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."BlockUser_blockID_seq"', 1, false);


--
-- Name: Chat_chatID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Chat_chatID_seq"', 1, false);


--
-- Name: CommentLike_commentLikeID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."CommentLike_commentLikeID_seq"', 1, false);


--
-- Name: Comment_commentID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Comment_commentID_seq"', 1, false);


--
-- Name: Like_likeID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Like_likeID_seq"', 1, false);


--
-- Name: Message_messageID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Message_messageID_seq"', 1, false);


--
-- Name: Post_Post_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Post_Post_id_seq"', 5, true);


--
-- Name: Story_storyID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Story_storyID_seq"', 1, false);


--
-- Name: UserPost_userpostIdentityID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."UserPost_userpostIdentityID_seq"', 4, true);


--
-- Name: UserStory_userStoryID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."UserStory_userStoryID_seq"', 1, false);


--
-- Name: UserStory_userStoryIdentityID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."UserStory_userStoryIdentityID_seq"', 1, false);


--
-- Name: User_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."User_user_id_seq"', 17, true);


--
-- Name: BlockUser BlockUser_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."BlockUser"
    ADD CONSTRAINT "BlockUser_pkey" PRIMARY KEY ("ownerID", "blockID");


--
-- Name: Close Friends Close Friends_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Close Friends"
    ADD CONSTRAINT "Close Friends_pkey" PRIMARY KEY ("ownerID", "friendsID");


--
-- Name: CommentLike CommentLike_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."CommentLike"
    ADD CONSTRAINT "CommentLike_pkey" PRIMARY KEY ("commentLikeID");


--
-- Name: Following Following_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Following"
    ADD CONSTRAINT "Following_pkey" PRIMARY KEY ("ownerID", "followedID");


--
-- Name: NumberOfFollower NumberOfFollower_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."NumberOfFollower"
    ADD CONSTRAINT "NumberOfFollower_pkey" PRIMARY KEY ("userID");


--
-- Name: Post Post_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Post"
    ADD CONSTRAINT "Post_pkey" PRIMARY KEY ("postID");


--
-- Name: Story Story_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Story"
    ADD CONSTRAINT "Story_pkey" PRIMARY KEY ("storyID");


--
-- Name: UserPost UserPost_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."UserPost"
    ADD CONSTRAINT "UserPost_pkey" PRIMARY KEY ("userpostIdentityID");


--
-- Name: UserStory UserStory_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."UserStory"
    ADD CONSTRAINT "UserStory_pkey" PRIMARY KEY ("userStoryIdentityID");


--
-- Name: User User_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_pkey" PRIMARY KEY ("userID");


--
-- Name: Chat unique_Chat_chatID; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Chat"
    ADD CONSTRAINT "unique_Chat_chatID" PRIMARY KEY ("chatID");


--
-- Name: CommentLike unique_CommentLike_commentLikeID; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."CommentLike"
    ADD CONSTRAINT "unique_CommentLike_commentLikeID" UNIQUE ("commentLikeID");


--
-- Name: Comment unique_Comment_commentID; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Comment"
    ADD CONSTRAINT "unique_Comment_commentID" PRIMARY KEY ("commentID");


--
-- Name: Like unique_Like_likeID; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Like"
    ADD CONSTRAINT "unique_Like_likeID" PRIMARY KEY ("likeID");


--
-- Name: Message unique_Message_messageID; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Message"
    ADD CONSTRAINT "unique_Message_messageID" PRIMARY KEY ("messageID");


--
-- Name: NumberOfFollower unique_NumberOfFollower_userID; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."NumberOfFollower"
    ADD CONSTRAINT "unique_NumberOfFollower_userID" UNIQUE ("userID");


--
-- Name: Story unique_Story_story_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Story"
    ADD CONSTRAINT "unique_Story_story_id" UNIQUE ("storyID");


--
-- Name: UserPost unique_UserPost_userpostID; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."UserPost"
    ADD CONSTRAINT "unique_UserPost_userpostID" UNIQUE ("userpostIdentityID");


--
-- Name: UserStory unique_UserStory_userStoryIdentityID; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."UserStory"
    ADD CONSTRAINT "unique_UserStory_userStoryIdentityID" UNIQUE ("userStoryIdentityID");


--
-- Name: User unique_User_user_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "unique_User_user_id" UNIQUE ("userID");


--
-- Name: User unique_User_username; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "unique_User_username" UNIQUE (username);


--
-- Name: index_Chat_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "index_Chat_id" ON public."Message" USING btree ("Chat_id");


--
-- Name: index_Post_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "index_Post_id" ON public."Comment" USING btree ("Post_id");


--
-- Name: index_User_id_2; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "index_User_id_2" ON public."Message" USING btree ("receiverID");


--
-- Name: index_blockID; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "index_blockID" ON public."BlockUser" USING btree ("blockID");


--
-- Name: index_userStoryID; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "index_userStoryID" ON public."UserStory" USING btree ("userStoryID");


--
-- Name: User CreateFollowerTable; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER "CreateFollowerTable" AFTER INSERT ON public."User" FOR EACH ROW EXECUTE FUNCTION public.createnumberoffollowertable();


--
-- Name: User DeleteNumberOfFollowerRow; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER "DeleteNumberOfFollowerRow" AFTER DELETE ON public."User" FOR EACH ROW EXECUTE FUNCTION public.deletenumberoffollowerrow();


--
-- Name: User DownUserCount; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER "DownUserCount" AFTER DELETE ON public."User" FOR EACH ROW EXECUTE FUNCTION public.usercountdown();


--
-- Name: Following FollowerUpdate; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER "FollowerUpdate" AFTER INSERT ON public."Following" FOR EACH ROW EXECUTE FUNCTION public.increasefollowernumber();


--
-- Name: User IncreaseUserCount; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER "IncreaseUserCount" AFTER INSERT ON public."User" FOR EACH ROW EXECUTE FUNCTION public.usercount();


--
-- Name: Post NumberOfPostIncrease; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER "NumberOfPostIncrease" AFTER INSERT ON public."Post" FOR EACH ROW EXECUTE FUNCTION public.usercount();


--
-- Name: Post PostTrigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER "PostTrigger" AFTER INSERT ON public."Post" FOR EACH ROW EXECUTE FUNCTION public.posttrigger();


--
-- Name: Message lnk_Chat_Message; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Message"
    ADD CONSTRAINT "lnk_Chat_Message" FOREIGN KEY ("Chat_id") REFERENCES public."Chat"("chatID") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: CommentLike lnk_Comment_CommentLike; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."CommentLike"
    ADD CONSTRAINT "lnk_Comment_CommentLike" FOREIGN KEY ("commentID") REFERENCES public."Comment"("commentID") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Comment lnk_Post_Comment; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Comment"
    ADD CONSTRAINT "lnk_Post_Comment" FOREIGN KEY ("Post_id") REFERENCES public."Post"("postID") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Like lnk_Post_Like; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Like"
    ADD CONSTRAINT "lnk_Post_Like" FOREIGN KEY ("postID") REFERENCES public."Post"("postID") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: UserPost lnk_Post_UserPost; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."UserPost"
    ADD CONSTRAINT "lnk_Post_UserPost" FOREIGN KEY ("userPostID") REFERENCES public."Post"("postID") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: UserStory lnk_Story_UserStory; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."UserStory"
    ADD CONSTRAINT "lnk_Story_UserStory" FOREIGN KEY ("userStoryID") REFERENCES public."Story"("storyID") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: BlockUser lnk_User_BlockUser; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."BlockUser"
    ADD CONSTRAINT "lnk_User_BlockUser" FOREIGN KEY ("ownerID") REFERENCES public."User"("userID") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: BlockUser lnk_User_BlockUser_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."BlockUser"
    ADD CONSTRAINT "lnk_User_BlockUser_2" FOREIGN KEY ("blockID") REFERENCES public."User"("userID") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Chat lnk_User_Chat; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Chat"
    ADD CONSTRAINT "lnk_User_Chat" FOREIGN KEY ("userID") REFERENCES public."User"("userID") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Chat lnk_User_Chat_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Chat"
    ADD CONSTRAINT "lnk_User_Chat_2" FOREIGN KEY ("receiverID") REFERENCES public."User"("userID") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Close Friends lnk_User_Close Friends; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Close Friends"
    ADD CONSTRAINT "lnk_User_Close Friends" FOREIGN KEY ("ownerID") REFERENCES public."User"("userID") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Close Friends lnk_User_Close Friends_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Close Friends"
    ADD CONSTRAINT "lnk_User_Close Friends_2" FOREIGN KEY ("friendsID") REFERENCES public."User"("userID") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Comment lnk_User_Comment; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Comment"
    ADD CONSTRAINT "lnk_User_Comment" FOREIGN KEY ("User_id") REFERENCES public."User"("userID") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: CommentLike lnk_User_CommentLike; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."CommentLike"
    ADD CONSTRAINT "lnk_User_CommentLike" FOREIGN KEY ("likedUserID") REFERENCES public."User"("userID") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Following lnk_User_Following; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Following"
    ADD CONSTRAINT "lnk_User_Following" FOREIGN KEY ("ownerID") REFERENCES public."User"("userID") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Following lnk_User_Following_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Following"
    ADD CONSTRAINT "lnk_User_Following_2" FOREIGN KEY ("followedID") REFERENCES public."User"("userID") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Like lnk_User_Like; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Like"
    ADD CONSTRAINT "lnk_User_Like" FOREIGN KEY ("userID") REFERENCES public."User"("userID") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Message lnk_User_Message; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Message"
    ADD CONSTRAINT "lnk_User_Message" FOREIGN KEY ("ownerID") REFERENCES public."User"("userID") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Message lnk_User_Message_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Message"
    ADD CONSTRAINT "lnk_User_Message_2" FOREIGN KEY ("receiverID") REFERENCES public."User"("userID") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: NumberOfFollower lnk_User_NumberOfFollower; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."NumberOfFollower"
    ADD CONSTRAINT "lnk_User_NumberOfFollower" FOREIGN KEY ("userID") REFERENCES public."User"("userID") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Post lnk_User_Post; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Post"
    ADD CONSTRAINT "lnk_User_Post" FOREIGN KEY ("User_id") REFERENCES public."User"("userID") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: UserPost lnk_User_UserPost; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."UserPost"
    ADD CONSTRAINT "lnk_User_UserPost" FOREIGN KEY ("userPostID") REFERENCES public."User"("userID") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: UserStory lnk_User_UserStory; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."UserStory"
    ADD CONSTRAINT "lnk_User_UserStory" FOREIGN KEY ("userStoryID") REFERENCES public."User"("userID") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

