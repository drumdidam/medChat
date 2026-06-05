--
-- PostgreSQL database dump
--

\restrict KUsQIunh1toLTyEashQGHBh0MYmQdd9V4hJH2yv5yagrObZCpcVqtwQSobJBQzF

-- Dumped from database version 17.10
-- Dumped by pg_dump version 17.10

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: drizzle; Type: SCHEMA; Schema: -; Owner: medchat
--

CREATE SCHEMA drizzle;


ALTER SCHEMA drizzle OWNER TO medchat;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: __drizzle_migrations; Type: TABLE; Schema: drizzle; Owner: medchat
--

CREATE TABLE drizzle.__drizzle_migrations (
    id integer NOT NULL,
    hash text NOT NULL,
    created_at bigint
);


ALTER TABLE drizzle.__drizzle_migrations OWNER TO medchat;

--
-- Name: __drizzle_migrations_id_seq; Type: SEQUENCE; Schema: drizzle; Owner: medchat
--

CREATE SEQUENCE drizzle.__drizzle_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE drizzle.__drizzle_migrations_id_seq OWNER TO medchat;

--
-- Name: __drizzle_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: drizzle; Owner: medchat
--

ALTER SEQUENCE drizzle.__drizzle_migrations_id_seq OWNED BY drizzle.__drizzle_migrations.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: medchat
--

CREATE TABLE public.categories (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    description text
);


ALTER TABLE public.categories OWNER TO medchat;

--
-- Name: posts; Type: TABLE; Schema: public; Owner: medchat
--

CREATE TABLE public.posts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    content text NOT NULL,
    user_id uuid,
    topic_id uuid NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    attachments text[] DEFAULT '{}'::text[] NOT NULL
);


ALTER TABLE public.posts OWNER TO medchat;

--
-- Name: roles; Type: TABLE; Schema: public; Owner: medchat
--

CREATE TABLE public.roles (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    permissions jsonb DEFAULT '{}'::jsonb NOT NULL
);


ALTER TABLE public.roles OWNER TO medchat;

--
-- Name: topics; Type: TABLE; Schema: public; Owner: medchat
--

CREATE TABLE public.topics (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    title text NOT NULL,
    description text,
    user_id uuid,
    category_id uuid,
    is_resolved boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.topics OWNER TO medchat;

--
-- Name: users; Type: TABLE; Schema: public; Owner: medchat
--

CREATE TABLE public.users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    email text NOT NULL,
    password text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    username text NOT NULL,
    role_id uuid,
    is_verified boolean DEFAULT false NOT NULL,
    verification_document text,
    specialty text,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    first_name text,
    last_name text,
    date_of_birth timestamp without time zone,
    home_country text,
    institution text,
    avatar_url text,
    verify_token text,
    verify_token_expiry timestamp without time zone,
    is_document_verified boolean DEFAULT false NOT NULL,
    document_verified_at timestamp without time zone,
    document_verified_by uuid
);


ALTER TABLE public.users OWNER TO medchat;

--
-- Name: __drizzle_migrations id; Type: DEFAULT; Schema: drizzle; Owner: medchat
--

ALTER TABLE ONLY drizzle.__drizzle_migrations ALTER COLUMN id SET DEFAULT nextval('drizzle.__drizzle_migrations_id_seq'::regclass);


--
-- Data for Name: __drizzle_migrations; Type: TABLE DATA; Schema: drizzle; Owner: medchat
--

COPY drizzle.__drizzle_migrations (id, hash, created_at) FROM stdin;
\.


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: medchat
--

COPY public.categories (id, name, description) FROM stdin;
e18ae4d5-f0fb-4d0c-8fdf-61639c50629d	Internal Medicine	Diagnosis and treatment of diseases affecting internal organs such as the heart, lungs, kidneys and gastrointestinal tract
0b93ef96-9841-4c77-8577-47983ac6e313	Surgery	Operative treatment of injuries, diseases and malformations
5bf2351f-94dc-43b2-91ab-19ac88af2acc	Neurology	Diseases of the brain, spinal cord and peripheral nervous system
11798886-d6c6-4887-a076-e1ad4084c57c	Cardiology	Diagnosis and therapy of heart diseases and vascular conditions
bb3b0f41-0678-4099-9570-4f0b1d910bb2	Orthopedics & Trauma Surgery	Diseases and injuries of the musculoskeletal system – bones, joints, muscles and ligaments
b26643c4-deeb-4890-abb5-893371db64ed	Pediatrics	Medical care of infants, children and adolescents
5d20a39f-6334-4a4f-a8e7-654f8e4ac18a	Psychiatry & Psychosomatics	Mental illnesses, behavioral disorders and psychosomatic conditions
69eb6eac-dc44-4690-9c14-306e4b12cd13	Gynecology & Obstetrics	Diseases of the female reproductive system as well as pregnancy, childbirth and postpartum care
f8480e8c-b3dd-46b7-a0a5-da18329e2e8f	Dermatology	Diseases of the skin, hair and nails as well as allergological conditions
b88ebffe-6dd8-4e06-bcac-5f1029c1b9f0	Radiology	Diagnostic imaging and interventional procedures using X-ray, CT, MRI and ultrasound
1c7fd4a2-2b2a-43f0-bdba-87bf176ff02e	Anesthesiology & Intensive Care	Anesthesia, pain management and intensive care treatment of critically ill patients
45d7cebf-5b90-4372-8056-bcfda694ba9d	Urology	Diseases of the urinary tract and male reproductive organs
f38bae73-254c-493b-9b1a-234b9058b901	Ophthalmology	Diseases of the eye and visual pathway
9a8d4c09-adbe-4c98-bd58-d7e83cbc59d1	ENT (Ear, Nose & Throat)	Diseases of the throat, nose, ears as well as swallowing and voice disorders
93294eb5-198e-4908-9ab6-95781a578ffd	Emergency Medicine	Acute care of life-threatening conditions and pre-hospital emergency medicine
\.


--
-- Data for Name: posts; Type: TABLE DATA; Schema: public; Owner: medchat
--

COPY public.posts (id, content, user_id, topic_id, created_at, updated_at, attachments) FROM stdin;
8e6a1068-d7bd-4ad4-8024-7e1899570922	Ich habe ein Problem mit xy	20262d95-4474-4b89-b0fa-37060455a794	772d0a4f-0ee7-4f94-b303-813c57de42cf	2026-05-27 21:06:56.186666	2026-05-27 21:06:56.186666	{}
b1b2895b-e524-4299-b79a-b3fec390c995	Post-TAVI troponin elevation is very common and usually reflects myocardial injury from the procedure itself. An 8x ULN rise in a hemodynamically stable patient is within what we typically see. I'd follow serial ECGs and echo at 24h to rule out new WMA.	20262d95-4474-4b89-b0fa-37060455a794	ac773696-c920-411b-b527-9a4ccb7b60ca	2026-05-27 22:02:00.608439	2026-05-27 22:02:00.608439	{}
9e4f63b6-39a4-4ab0-8e29-5fa138771f32	Agreed. The key question is trajectory — is it peaking and coming down? Also worth checking if the patient had any periprocedural complications like coronary occlusion. If echo looks fine and patient is stable, watchful waiting is appropriate.	516b828d-625c-4136-8227-3d48e50c7b7e	ac773696-c920-411b-b527-9a4ccb7b60ca	2026-05-27 22:02:00.609658	2026-05-27 22:02:00.609658	{}
20804c83-ade3-48b7-9179-200b23b3c2c5	MRI is the gold standard here and worth the wait if the patient is stable. Don't delay if she deteriorates. Laparoscopic appendectomy in the 2nd trimester is well-tolerated — open port placement slightly higher than usual to account for the uterus.	516b828d-625c-4136-8227-3d48e50c7b7e	9394db8c-1760-4b49-b3a2-a1196de680ca	2026-05-27 22:02:00.611721	2026-05-27 22:02:00.611721	{}
4f1d7386-d452-48b3-bec9-aac0f27f8995	Surgeon here — we'd proceed with MRI if feasible. If she spikes a fever or peritoneal signs develop before imaging, take her to OR. The risk of perforated appendicitis to the fetus is far greater than the surgical risk.	20262d95-4474-4b89-b0fa-37060455a794	9394db8c-1760-4b49-b3a2-a1196de680ca	2026-05-27 22:02:00.612672	2026-05-27 22:02:00.612672	{}
87415ec4-613f-4016-ae56-42c8686d79b5	The phrase 'worst headache of my life' with thunderclap onset mandates LP or CTA regardless of migraine history. CT sensitivity for SAH drops after 6h. Don't anchor on the migraine history.	20262d95-4474-4b89-b0fa-37060455a794	1da04045-c9bd-410c-a5db-4e80e12b6292	2026-05-27 22:02:00.614712	2026-05-27 22:02:00.614712	{}
db13f3dd-1111-44b4-8c48-b7fcb436e19c	Ottawa SAH rule is useful here — if onset was truly sudden and maximal at onset, LP is warranted even with negative CT. Xanthochromia in CSF is your answer.	516b828d-625c-4136-8227-3d48e50c7b7e	1da04045-c9bd-410c-a5db-4e80e12b6292	2026-05-27 22:02:00.61566	2026-05-27 22:02:00.61566	{}
cbf06866-582c-4c91-9339-4f7d902bf7b6	One caveat: if CT was within 6h and is negative, sensitivity for SAH is ~98%. Some centers skip LP in that scenario. Discuss with neurology and document the shared decision.	20262d95-4474-4b89-b0fa-37060455a794	1da04045-c9bd-410c-a5db-4e80e12b6292	2026-05-27 22:02:00.616685	2026-05-27 22:02:00.616685	{}
163e6177-0c88-4214-9d36-c147c4f846eb	At 9 months and fully vaccinated, the risk of occult bacteremia is very low. For a well-appearing child I'd do a UA/urine culture (UTI is still the main concern in this age group) and reassess. I wouldn't reflexively LP a well-looking vaccinated infant.	516b828d-625c-4136-8227-3d48e50c7b7e	6d80a53f-1b0d-4189-abbf-a41e3c6f325f	2026-05-27 22:02:00.619016	2026-05-27 22:02:00.619016	{}
538445ed-af14-4dd1-8a77-e03d297575f4	Agree on urine. Use the Rochester or Philadelphia criteria if you're on the fence. If the child is well-appearing and you can ensure solid follow-up, a watchful waiting approach with clear return precautions is reasonable.	20262d95-4474-4b89-b0fa-37060455a794	6d80a53f-1b0d-4189-abbf-a41e3c6f325f	2026-05-27 22:02:00.619933	2026-05-27 22:02:00.619933	{}
3c5f27ad-ce6c-40ab-a41e-7867b5c953ef	For acute agitation I typically use droperidol or haloperidol IM — fast onset, reliable. Olanzapine IM is also effective but avoid combining it with benzodiazepines due to respiratory depression risk. Get an ECG if you can.	20262d95-4474-4b89-b0fa-37060455a794	42b056cb-9756-45bc-b97e-7e6693f2e4b0	2026-05-27 22:02:00.621864	2026-05-27 22:02:00.621864	{}
e08e9626-f33f-4494-bbe4-f8f6164dc096	Our ED protocol uses haloperidol 5mg + lorazepam 2mg IM (B52). For excited delirium or if substance use is suspected, ketamine IM is increasingly used for rapid control. Always have resuscitation equipment ready.	516b828d-625c-4136-8227-3d48e50c7b7e	42b056cb-9756-45bc-b97e-7e6693f2e4b0	2026-05-27 22:02:00.622765	2026-05-27 22:02:00.622765	{}
0b05a8f9-beb2-4cb7-a1c4-e6cf812bb222	With hCG under 1500 and a small adnexal mass, expectant management is a valid option if the patient is compliant and you have reliable follow-up. Repeat hCG in 48h — if it drops >15%, continue watching. MTX if it plateaus or rises.	516b828d-625c-4136-8227-3d48e50c7b7e	06dd8918-121b-41a3-a32e-276f7397bfc7	2026-05-27 22:02:00.624625	2026-05-27 22:02:00.624625	{}
5da08ec3-622c-47cf-9fb0-02241f9e209c	I'd lean toward MTX here — single dose is well-tolerated and avoids the uncertainty of expectant management. Make sure there are no contraindications (renal/liver function, blood count). Counsel about the ectopic rupture risk even post-MTX.	20262d95-4474-4b89-b0fa-37060455a794	06dd8918-121b-41a3-a32e-276f7397bfc7	2026-05-27 22:02:00.625798	2026-05-27 22:02:00.625798	{}
4b106922-4248-4159-8c3b-227720dfea4a	If imaging is delayed and clinical suspicion for DVT is high, anticoagulation is reasonable. Antibiotics won't hurt if cellulitis coexists. Mark the erythema border with a skin marker to track progression.	516b828d-625c-4136-8227-3d48e50c7b7e	dcf250cc-39ef-48bc-967c-4ac0d7511a91	2026-05-27 22:02:00.628735	2026-05-27 22:02:00.628735	{}
a0ad7a9f-a5bb-4106-99c1-7e8f28a68fd8	This sounds like classic erythema infectiosum (fifth disease / parvovirus B19). The slapped cheek appearance followed by a lacy reticular rash on the trunk is pathognomonic. Management is supportive. Key point: patient is no longer infectious once the rash appears.	516b828d-625c-4136-8227-3d48e50c7b7e	03e6ee93-5c33-4afd-8eaf-72cb83c353d3	2026-05-27 22:02:00.630717	2026-05-27 22:02:00.630717	{}
80d179e8-245f-476e-ade2-3fe989970700	Rubella would present with Forchheimer spots (petechiae on soft palate), lymphadenopathy, and a more diffuse maculopapular rash. With no vaccination record, serology can confirm — important especially if there's contact with pregnant women.	20262d95-4474-4b89-b0fa-37060455a794	03e6ee93-5c33-4afd-8eaf-72cb83c353d3	2026-05-27 22:02:00.631691	2026-05-27 22:02:00.631691	{}
62f1fcee-6b39-4845-905a-6e1858d4f2e8	A density of 15 HU is above the 10 HU threshold for lipid-rich adenoma. You'd want a dedicated adrenal protocol CT with washout values. If absolute washout >60% or relative >40%, adenoma is confirmed. Also check bloods: metanephrines, aldosterone/renin ratio, cortisol suppression test.	20262d95-4474-4b89-b0fa-37060455a794	e7366d37-b323-4aac-89fc-774a2e0c0e2f	2026-05-27 22:02:00.633901	2026-05-27 22:02:00.633901	{}
ea496cc0-9c37-46fa-8745-5962c08d6931	The endocrine workup is mandatory regardless of imaging — you need to rule out pheo before any intervention or anesthesia. Size <4cm with benign imaging features and negative biochemistry = follow-up imaging at 6–12 months.	516b828d-625c-4136-8227-3d48e50c7b7e	e7366d37-b323-4aac-89fc-774a2e0c0e2f	2026-05-27 22:02:00.634786	2026-05-27 22:02:00.634786	{}
cc17963c-3853-4d5f-ad1b-6d82ab29a704	The ICP concern with succinylcholine is largely theoretical — the fasciculations may transiently raise ICP but the clinical significance in most TBI patients is minimal. The rapid onset and offset are valuable if you need to reassess neuro status. Rocuronium at 1.2mg/kg is a solid alternative with sugammadex available.	516b828d-625c-4136-8227-3d48e50c7b7e	b8d7eeac-d7ee-41d7-be79-afc54e9aafb0	2026-05-27 22:02:00.636617	2026-05-27 22:02:00.636617	{}
b28a0ea7-dbea-4527-99ea-43ccff9985f5	We use rocuronium + ketamine for most trauma RSIs now. Ketamine's ICP effects have been largely debunked and its cardiovascular stability is useful in hypotensive trauma patients. Avoid etomidate if adrenal suppression is a concern.	20262d95-4474-4b89-b0fa-37060455a794	b8d7eeac-d7ee-41d7-be79-afc54e9aafb0	2026-05-27 22:02:00.637523	2026-05-27 22:02:00.637523	{}
b10e1f33-0e3d-445b-bb20-5ca1689f489b	Post-TAVI troponin elevation is very common and usually reflects myocardial injury from the procedure itself. An 8x ULN rise in a hemodynamically stable patient is within what we typically see. I'd follow serial ECGs and echo at 24h to rule out new WMA.	20262d95-4474-4b89-b0fa-37060455a794	d6ec0711-5a7f-4550-8ba3-f981f04d9002	2026-05-30 10:23:51.045499	2026-05-30 10:23:51.045499	{}
b38f58da-1f60-4466-9ec7-1e9c783ab8bb	Agreed. The key question is trajectory — is it peaking and coming down? Also worth checking if the patient had any periprocedural complications like coronary occlusion. If echo looks fine and patient is stable, watchful waiting is appropriate.	516b828d-625c-4136-8227-3d48e50c7b7e	d6ec0711-5a7f-4550-8ba3-f981f04d9002	2026-05-30 10:23:51.046371	2026-05-30 10:23:51.046371	{}
0ae2b360-0817-4027-b0ef-a599be9a3894	MRI is the gold standard here and worth the wait if the patient is stable. Don't delay if she deteriorates. Laparoscopic appendectomy in the 2nd trimester is well-tolerated — open port placement slightly higher than usual to account for the uterus.	516b828d-625c-4136-8227-3d48e50c7b7e	8d30ea4a-251c-4675-b1c9-c4ab961b4e6a	2026-05-30 10:23:51.047691	2026-05-30 10:23:51.047691	{}
a31ed4f4-3e0a-4da1-a019-e1190ff79f4b	Surgeon here — we'd proceed with MRI if feasible. If she spikes a fever or peritoneal signs develop before imaging, take her to OR. The risk of perforated appendicitis to the fetus is far greater than the surgical risk.	20262d95-4474-4b89-b0fa-37060455a794	8d30ea4a-251c-4675-b1c9-c4ab961b4e6a	2026-05-30 10:23:51.04832	2026-05-30 10:23:51.04832	{}
532fa44b-0d6b-4651-8ebb-f6c043e86a7a	The phrase 'worst headache of my life' with thunderclap onset mandates LP or CTA regardless of migraine history. CT sensitivity for SAH drops after 6h. Don't anchor on the migraine history.	20262d95-4474-4b89-b0fa-37060455a794	85a321f5-88e1-4717-a247-886944760f79	2026-05-30 10:23:51.049584	2026-05-30 10:23:51.049584	{}
b2bad64f-e4d0-4a8e-9baa-125fe5ace5bb	Ottawa SAH rule is useful here — if onset was truly sudden and maximal at onset, LP is warranted even with negative CT. Xanthochromia in CSF is your answer.	516b828d-625c-4136-8227-3d48e50c7b7e	85a321f5-88e1-4717-a247-886944760f79	2026-05-30 10:23:51.050165	2026-05-30 10:23:51.050165	{}
5ff51792-9c60-4e6d-ab7e-60d02c6039ab	One caveat: if CT was within 6h and is negative, sensitivity for SAH is ~98%. Some centers skip LP in that scenario. Discuss with neurology and document the shared decision.	20262d95-4474-4b89-b0fa-37060455a794	85a321f5-88e1-4717-a247-886944760f79	2026-05-30 10:23:51.050692	2026-05-30 10:23:51.050692	{}
cbe08308-36be-4a99-a8c1-a0023645ec57	At 9 months and fully vaccinated, the risk of occult bacteremia is very low. For a well-appearing child I'd do a UA/urine culture (UTI is still the main concern in this age group) and reassess. I wouldn't reflexively LP a well-looking vaccinated infant.	516b828d-625c-4136-8227-3d48e50c7b7e	f910a35f-4b4c-4aab-9aad-c8d40111addf	2026-05-30 10:23:51.051792	2026-05-30 10:23:51.051792	{}
7b88bbae-ec5d-4dd4-9827-f965da29c996	Agree on urine. Use the Rochester or Philadelphia criteria if you're on the fence. If the child is well-appearing and you can ensure solid follow-up, a watchful waiting approach with clear return precautions is reasonable.	20262d95-4474-4b89-b0fa-37060455a794	f910a35f-4b4c-4aab-9aad-c8d40111addf	2026-05-30 10:23:51.052275	2026-05-30 10:23:51.052275	{}
3f416946-d3d9-4550-b48d-95456cfb2b74	For acute agitation I typically use droperidol or haloperidol IM — fast onset, reliable. Olanzapine IM is also effective but avoid combining it with benzodiazepines due to respiratory depression risk. Get an ECG if you can.	20262d95-4474-4b89-b0fa-37060455a794	e3d84508-f57f-4c4f-a1b0-4a5496e3de02	2026-05-30 10:23:51.053351	2026-05-30 10:23:51.053351	{}
f4b7bae0-f828-479a-b8b2-73dab9587f52	Our ED protocol uses haloperidol 5mg + lorazepam 2mg IM (B52). For excited delirium or if substance use is suspected, ketamine IM is increasingly used for rapid control. Always have resuscitation equipment ready.	516b828d-625c-4136-8227-3d48e50c7b7e	e3d84508-f57f-4c4f-a1b0-4a5496e3de02	2026-05-30 10:23:51.05383	2026-05-30 10:23:51.05383	{}
41aa5ea9-3aa1-411d-a740-99a8a21bda07	With hCG under 1500 and a small adnexal mass, expectant management is a valid option if the patient is compliant and you have reliable follow-up. Repeat hCG in 48h — if it drops >15%, continue watching. MTX if it plateaus or rises.	516b828d-625c-4136-8227-3d48e50c7b7e	f4ab174a-c0b8-4709-8a3e-e04d171a1e43	2026-05-30 10:23:51.054928	2026-05-30 10:23:51.054928	{}
e52606d9-25e1-45c8-bbe5-239c39e48f59	I'd lean toward MTX here — single dose is well-tolerated and avoids the uncertainty of expectant management. Make sure there are no contraindications (renal/liver function, blood count). Counsel about the ectopic rupture risk even post-MTX.	20262d95-4474-4b89-b0fa-37060455a794	f4ab174a-c0b8-4709-8a3e-e04d171a1e43	2026-05-30 10:23:51.055453	2026-05-30 10:23:51.055453	{}
f81a0462-73e5-4bdb-81ca-4ba0116b9bae	Classic dilemma. Cellulitis typically has a clear leading edge, fever, and systemic signs. DVT can look very similar. With a Wells score of 2 and elevated D-dimer, duplex is mandatory — don't delay it. I wouldn't start anticoagulation empirically before imaging unless the wait is >24h.	20262d95-4474-4b89-b0fa-37060455a794	c8c4dc16-35aa-42fa-aae7-421177c9e275	2026-05-30 10:23:51.056537	2026-05-30 10:23:51.056537	{}
8866a56e-6506-4cec-a316-0bb4f7bb1c81	If imaging is delayed and clinical suspicion for DVT is high, anticoagulation is reasonable. Antibiotics won't hurt if cellulitis coexists. Mark the erythema border with a skin marker to track progression.	516b828d-625c-4136-8227-3d48e50c7b7e	c8c4dc16-35aa-42fa-aae7-421177c9e275	2026-05-30 10:23:51.057061	2026-05-30 10:23:51.057061	{}
ecb836bc-c61e-4447-8832-e980011245e6	This sounds like classic erythema infectiosum (fifth disease / parvovirus B19). The slapped cheek appearance followed by a lacy reticular rash on the trunk is pathognomonic. Management is supportive. Key point: patient is no longer infectious once the rash appears.	516b828d-625c-4136-8227-3d48e50c7b7e	5032c93c-fb5d-437b-9c6d-c7b0fb391ff7	2026-05-30 10:23:51.058522	2026-05-30 10:23:51.058522	{}
c58b6990-923c-42d5-b0d0-5d43b0d29a79	Rubella would present with Forchheimer spots (petechiae on soft palate), lymphadenopathy, and a more diffuse maculopapular rash. With no vaccination record, serology can confirm — important especially if there's contact with pregnant women.	20262d95-4474-4b89-b0fa-37060455a794	5032c93c-fb5d-437b-9c6d-c7b0fb391ff7	2026-05-30 10:23:51.059024	2026-05-30 10:23:51.059024	{}
066c52ee-00dc-43c2-9187-8a94f69bc19a	A density of 15 HU is above the 10 HU threshold for lipid-rich adenoma. You'd want a dedicated adrenal protocol CT with washout values. If absolute washout >60% or relative >40%, adenoma is confirmed. Also check bloods: metanephrines, aldosterone/renin ratio, cortisol suppression test.	20262d95-4474-4b89-b0fa-37060455a794	18bf3b6a-e819-4c25-9f6f-00847007e174	2026-05-30 10:23:51.060211	2026-05-30 10:23:51.060211	{}
3ac7e694-4a5a-41ab-b6c2-6e1fbc5c2aef	The endocrine workup is mandatory regardless of imaging — you need to rule out pheo before any intervention or anesthesia. Size <4cm with benign imaging features and negative biochemistry = follow-up imaging at 6–12 months.	516b828d-625c-4136-8227-3d48e50c7b7e	18bf3b6a-e819-4c25-9f6f-00847007e174	2026-05-30 10:23:51.060732	2026-05-30 10:23:51.060732	{}
62962444-0555-467c-b8e2-2de9862185ea	The ICP concern with succinylcholine is largely theoretical — the fasciculations may transiently raise ICP but the clinical significance in most TBI patients is minimal. The rapid onset and offset are valuable if you need to reassess neuro status. Rocuronium at 1.2mg/kg is a solid alternative with sugammadex available.	516b828d-625c-4136-8227-3d48e50c7b7e	fe9d9f20-8e72-4fff-a43c-5bfe3600a59e	2026-05-30 10:23:51.061859	2026-05-30 10:23:51.061859	{}
9f2218a9-a7bf-415b-b102-0dbe5f428293	We use rocuronium + ketamine for most trauma RSIs now. Ketamine's ICP effects have been largely debunked and its cardiovascular stability is useful in hypotensive trauma patients. Avoid etomidate if adrenal suppression is a concern.	20262d95-4474-4b89-b0fa-37060455a794	fe9d9f20-8e72-4fff-a43c-5bfe3600a59e	2026-05-30 10:23:51.062347	2026-05-30 10:23:51.062347	{}
53d64bbf-b3ab-44e4-b4d4-dc373dce250f	Klingt gut das würde ich auch machen.	1d5b97e7-c661-4d24-9114-1784f7004a53	8d30ea4a-251c-4675-b1c9-c4ab961b4e6a	2026-05-30 10:27:16.432049	2026-05-30 10:27:16.432049	{}
e6d4c549-2a00-4cc8-9ab9-4638174cbc8a	Test file upload	f596c56d-6c6c-4e24-8740-28f914d05e3e	9394db8c-1760-4b49-b3a2-a1196de680ca	2026-06-02 21:20:47.848138	2026-06-02 21:20:47.848138	{/uploads/249de430-1748-4b5b-b6c9-00a05cb0f290-1780435247845.png}
7535b753-b5ec-4935-bfc3-df5115b87918	I edited it 2 times!\n	f596c56d-6c6c-4e24-8740-28f914d05e3e	dcf250cc-39ef-48bc-967c-4ac0d7511a91	2026-05-31 18:44:55.40834	2026-05-31 18:44:55.40834	{}
5b8fa0d5-576a-4ed8-aa06-0cc733bbd6de	Hallo iam the admin	f596c56d-6c6c-4e24-8740-28f914d05e3e	c8c4dc16-35aa-42fa-aae7-421177c9e275	2026-06-01 21:33:43.584931	2026-06-01 21:33:43.584931	{}
81eb49c5-306b-4602-99d4-9716eaa12e52	Hallo this user is deleted	\N	c8c4dc16-35aa-42fa-aae7-421177c9e275	2026-06-04 19:21:50.063991	2026-06-04 19:21:50.063991	{}
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: medchat
--

COPY public.roles (id, name, permissions) FROM stdin;
c3d3cc77-7466-4911-8cf4-0f4160ed87c4	moderator	{"banUsers": true, "assignRoles": false, "createTopic": true, "viewContent": true, "markResolved": true, "systemConfig": false, "editOwnContent": true, "deleteAnyContent": true, "deleteOwnContent": true}
49495b76-c4fd-4caa-b323-2decb56c8ba6	admin	{"banUsers": true, "assignRoles": true, "createTopic": true, "viewContent": true, "markResolved": true, "systemConfig": true, "editOwnContent": true, "deleteAnyContent": true, "deleteOwnContent": true}
797ee556-2f70-44f1-9994-f6ace4a36e9d	user	{"banUsers": false, "assignRoles": false, "createTopic": true, "viewContent": true, "markResolved": false, "systemConfig": false, "editOwnContent": true, "deleteAnyContent": false, "deleteOwnContent": true}
\.


--
-- Data for Name: topics; Type: TABLE DATA; Schema: public; Owner: medchat
--

COPY public.topics (id, title, description, user_id, category_id, is_resolved, created_at, updated_at) FROM stdin;
c8c4dc16-35aa-42fa-aae7-421177c9e275	Differentiating cellulitis from DVT with leg swelling	Patient with unilateral leg swelling, erythema, warmth, and tenderness. D-dimer elevated. Wells score 2. Do you treat for both empirically while waiting for duplex?	516b828d-625c-4136-8227-3d48e50c7b7e	e18ae4d5-f0fb-4d0c-8fdf-61639c50629d	f	2026-05-30 10:23:51.056008	2026-05-30 10:23:51.056008
ac773696-c920-411b-b527-9a4ccb7b60ca	Troponin elevation after TAVI – how to interpret?	Patient had TAVI yesterday, troponin is now 8x ULN. Hemodynamically stable. Is this expected post-procedural release or should we be worried?	516b828d-625c-4136-8227-3d48e50c7b7e	11798886-d6c6-4887-a076-e1ad4084c57c	t	2026-05-27 22:02:00.606552	2026-05-27 22:02:00.606552
9394db8c-1760-4b49-b3a2-a1196de680ca	Best approach for acute appendicitis in pregnancy (2nd trimester)?	28-year-old at 20 weeks gestation presenting with RLQ pain, low-grade fever, leukocytosis. Ultrasound inconclusive. MRI ordered but 6h wait. How aggressive should we be?	20262d95-4474-4b89-b0fa-37060455a794	0b93ef96-9841-4c77-8577-47983ac6e313	f	2026-05-27 22:02:00.610721	2026-05-27 22:02:00.610721
1da04045-c9bd-410c-a5db-4e80e12b6292	Migraine vs. thunderclap headache – red flags in the ED?	23F with known migraine history presenting with 'worst headache of my life'. Has had similar before. How do you decide whether to LP?	516b828d-625c-4136-8227-3d48e50c7b7e	5bf2351f-94dc-43b2-91ab-19ac88af2acc	t	2026-05-27 22:02:00.613733	2026-05-27 22:02:00.613733
6d80a53f-1b0d-4189-abbf-a41e3c6f325f	Pediatric fever without source – when to do a septic workup?	9-month-old, 39.8°C, no focus found. Vaccinated. Well-appearing. Parents anxious. What's your threshold for blood culture, urine, LP?	20262d95-4474-4b89-b0fa-37060455a794	b26643c4-deeb-4890-abb5-893371db64ed	f	2026-05-27 22:02:00.617955	2026-05-27 22:02:00.617955
42b056cb-9756-45bc-b97e-7e6693f2e4b0	Managing acute psychosis – haloperidol vs. olanzapine in the ED?	35M brought in by police, severely agitated, unknown psychiatric history. Which antipsychotic do you reach for first and at what dose?	516b828d-625c-4136-8227-3d48e50c7b7e	5d20a39f-6334-4a4f-a8e7-654f8e4ac18a	f	2026-05-27 22:02:00.620867	2026-05-27 22:02:00.620867
06dd8918-121b-41a3-a32e-276f7397bfc7	Ectopic pregnancy – expectant management criteria?	hCG 1200, transvaginal ultrasound shows empty uterus with small adnexal mass. Hemodynamically stable, no free fluid. Methotrexate vs. expectant?	20262d95-4474-4b89-b0fa-37060455a794	69eb6eac-dc44-4690-9c14-306e4b12cd13	t	2026-05-27 22:02:00.623674	2026-05-27 22:02:00.623674
03e6ee93-5c33-4afd-8eaf-72cb83c353d3	Typical rash in a 6-year-old – slapped cheek vs. rubella?	Child presenting with bright red facial rash spreading to trunk, low-grade fever 2 days prior, now afebrile. No vaccination records available.	20262d95-4474-4b89-b0fa-37060455a794	f8480e8c-b3dd-46b7-a0a5-da18329e2e8f	t	2026-05-27 22:02:00.629763	2026-05-27 22:02:00.629763
e7366d37-b323-4aac-89fc-774a2e0c0e2f	Interpreting incidental adrenal adenoma on CT – next steps?	CT abdomen for unrelated reason found a 2.1cm left adrenal mass with 15 HU density. Patient asymptomatic, normotensive.	516b828d-625c-4136-8227-3d48e50c7b7e	b88ebffe-6dd8-4e06-bcac-5f1029c1b9f0	f	2026-05-27 22:02:00.632943	2026-05-27 22:02:00.632943
b8d7eeac-d7ee-41d7-be79-afc54e9aafb0	RSI drug choice in head trauma patient – succinylcholine safe?	GCS 8 after MVC, suspected TBI, no C-spine cleared. Need to intubate. Concern about ICP rise with succinylcholine?	20262d95-4474-4b89-b0fa-37060455a794	1c7fd4a2-2b2a-43f0-bdba-87bf176ff02e	t	2026-05-27 22:02:00.635691	2026-05-27 22:02:00.635691
772d0a4f-0ee7-4f94-b303-813c57de42cf	Cardiology	Heart etc	20262d95-4474-4b89-b0fa-37060455a794	11798886-d6c6-4887-a076-e1ad4084c57c	f	2026-05-27 17:38:56.143384	2026-05-27 17:38:56.143384
5bdfd31a-dd1f-4d13-a954-7abae3963e3d	Dermatology	Haut	20262d95-4474-4b89-b0fa-37060455a794	f8480e8c-b3dd-46b7-a0a5-da18329e2e8f	f	2026-05-27 18:07:50.895359	2026-05-27 18:07:50.895359
d6ec0711-5a7f-4550-8ba3-f981f04d9002	Troponin elevation after TAVI – how to interpret?	Patient had TAVI yesterday, troponin is now 8x ULN. Hemodynamically stable. Is this expected post-procedural release or should we be worried?	516b828d-625c-4136-8227-3d48e50c7b7e	11798886-d6c6-4887-a076-e1ad4084c57c	t	2026-05-30 10:23:51.044181	2026-05-30 10:23:51.044181
8d30ea4a-251c-4675-b1c9-c4ab961b4e6a	Best approach for acute appendicitis in pregnancy (2nd trimester)?	28-year-old at 20 weeks gestation presenting with RLQ pain, low-grade fever, leukocytosis. Ultrasound inconclusive. MRI ordered but 6h wait. How aggressive should we be?	20262d95-4474-4b89-b0fa-37060455a794	0b93ef96-9841-4c77-8577-47983ac6e313	f	2026-05-30 10:23:51.047044	2026-05-30 10:23:51.047044
85a321f5-88e1-4717-a247-886944760f79	Migraine vs. thunderclap headache – red flags in the ED?	23F with known migraine history presenting with 'worst headache of my life'. Has had similar before. How do you decide whether to LP?	516b828d-625c-4136-8227-3d48e50c7b7e	5bf2351f-94dc-43b2-91ab-19ac88af2acc	t	2026-05-30 10:23:51.048909	2026-05-30 10:23:51.048909
f910a35f-4b4c-4aab-9aad-c8d40111addf	Pediatric fever without source – when to do a septic workup?	9-month-old, 39.8°C, no focus found. Vaccinated. Well-appearing. Parents anxious. What's your threshold for blood culture, urine, LP?	20262d95-4474-4b89-b0fa-37060455a794	b26643c4-deeb-4890-abb5-893371db64ed	f	2026-05-30 10:23:51.05122	2026-05-30 10:23:51.05122
e3d84508-f57f-4c4f-a1b0-4a5496e3de02	Managing acute psychosis – haloperidol vs. olanzapine in the ED?	35M brought in by police, severely agitated, unknown psychiatric history. Which antipsychotic do you reach for first and at what dose?	516b828d-625c-4136-8227-3d48e50c7b7e	5d20a39f-6334-4a4f-a8e7-654f8e4ac18a	f	2026-05-30 10:23:51.052792	2026-05-30 10:23:51.052792
f4ab174a-c0b8-4709-8a3e-e04d171a1e43	Ectopic pregnancy – expectant management criteria?	hCG 1200, transvaginal ultrasound shows empty uterus with small adnexal mass. Hemodynamically stable, no free fluid. Methotrexate vs. expectant?	20262d95-4474-4b89-b0fa-37060455a794	69eb6eac-dc44-4690-9c14-306e4b12cd13	t	2026-05-30 10:23:51.054359	2026-05-30 10:23:51.054359
5032c93c-fb5d-437b-9c6d-c7b0fb391ff7	Typical rash in a 6-year-old – slapped cheek vs. rubella?	Child presenting with bright red facial rash spreading to trunk, low-grade fever 2 days prior, now afebrile. No vaccination records available.	20262d95-4474-4b89-b0fa-37060455a794	f8480e8c-b3dd-46b7-a0a5-da18329e2e8f	t	2026-05-30 10:23:51.057842	2026-05-30 10:23:51.057842
18bf3b6a-e819-4c25-9f6f-00847007e174	Interpreting incidental adrenal adenoma on CT – next steps?	CT abdomen for unrelated reason found a 2.1cm left adrenal mass with 15 HU density. Patient asymptomatic, normotensive.	516b828d-625c-4136-8227-3d48e50c7b7e	b88ebffe-6dd8-4e06-bcac-5f1029c1b9f0	f	2026-05-30 10:23:51.05961	2026-05-30 10:23:51.05961
fe9d9f20-8e72-4fff-a43c-5bfe3600a59e	RSI drug choice in head trauma patient – succinylcholine safe?	GCS 8 after MVC, suspected TBI, no C-spine cleared. Need to intubate. Concern about ICP rise with succinylcholine?	20262d95-4474-4b89-b0fa-37060455a794	1c7fd4a2-2b2a-43f0-bdba-87bf176ff02e	t	2026-05-30 10:23:51.061299	2026-05-30 10:23:51.061299
dcf250cc-39ef-48bc-967c-4ac0d7511a91	Differentiating cellulitis from DVT with leg swelling	Patient with unilateral leg swelling, erythema, warmth, and tenderness. D-dimer elevated. Wells score 2. Do you treat for both empirically while waiting for duplex?	516b828d-625c-4136-8227-3d48e50c7b7e	e18ae4d5-f0fb-4d0c-8fdf-61639c50629d	t	2026-05-27 22:02:00.626747	2026-05-27 22:02:00.626747
96192709-fdf1-41be-9081-e67688c9635f	This is a thread from a deleted user	BALASDFJA;LSDJF;ALSDJK	\N	e18ae4d5-f0fb-4d0c-8fdf-61639c50629d	f	2026-06-04 19:27:09.576942	2026-06-04 19:27:09.576942
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: medchat
--

COPY public.users (id, email, password, created_at, username, role_id, is_verified, verification_document, specialty, updated_at, first_name, last_name, date_of_birth, home_country, institution, avatar_url, verify_token, verify_token_expiry, is_document_verified, document_verified_at, document_verified_by) FROM stdin;
20262d95-4474-4b89-b0fa-37060455a794	hallo@hallo.com	$2b$12$9QRkZwCvfKFfNjhhsc3AnuWGj7IDXkoxmYZfoJOQP59Z/z1SrnTO2	2026-05-27 17:11:19.41465	hallo	797ee556-2f70-44f1-9994-f6ace4a36e9d	f		Cardiology	2026-05-27 17:11:19.41465	\N	\N	\N	\N	\N	/uploads/20262d95-4474-4b89-b0fa-37060455a794-1780431623404.jpg	\N	\N	f	\N	\N
7f6c3b9f-8b91-498a-aa39-94693baf943b	sens@saliger.me	$2b$12$5tdJmtHgQxOGH0kDXrR.FeNP7IA1dycWdaOUm8LQ2d0R/o2uMcClm	2026-05-30 07:27:28.680403	snens	797ee556-2f70-44f1-9994-f6ace4a36e9d	f			2026-05-30 07:27:28.680403	\N	\N	\N	\N	\N	/uploads/7f6c3b9f-8b91-498a-aa39-94693baf943b-1780431624406.jpg	\N	\N	f	\N	\N
2cb4eb8f-1571-4515-8535-d3e1c2af8b94	moderator@medChat.com	$2b$12$XGuI3z.M2F1WxNCXQwNOguH1ypO8VcXWkT2w63oartvbXFQLTYTyC	2026-05-30 10:36:03.679561	moderator	c3d3cc77-7466-4911-8cf4-0f4160ed87c4	f			2026-05-30 10:36:03.679561	\N	\N	\N	\N	\N	/uploads/2cb4eb8f-1571-4515-8535-d3e1c2af8b94-1780431625409.jpg	\N	\N	f	\N	\N
cd3776a7-439f-4837-9054-7bbac12d6f8a	test@123.com	$2b$12$w.Bm2TDFK.z6aC6JhgzXye.tC1DjxUQU0yfdIwaymM/WLvbeNzfoG	2026-06-01 20:27:46.082638	test	797ee556-2f70-44f1-9994-f6ace4a36e9d	f			2026-06-01 20:27:46.082638	\N	\N	\N	\N	\N	/uploads/cd3776a7-439f-4837-9054-7bbac12d6f8a-1780431626412.jpg	\N	\N	f	\N	\N
516b828d-625c-4136-8227-3d48e50c7b7e	drumdidam@gmail.com	$2b$12$z81lnsYvuKqVerUp0seXZe2W54oU71yXfrdlNpiOBWNZZbiqjKuhm	2026-05-27 16:22:15.240904	drumdidam	797ee556-2f70-44f1-9994-f6ace4a36e9d	f	\N	\N	2026-05-27 17:07:39.502051	\N	\N	\N	\N	\N	/uploads/516b828d-625c-4136-8227-3d48e50c7b7e-1780431661720.jpg	\N	\N	f	\N	\N
e8fba98a-1e81-43ce-b659-f6e7792357f1	saramayer96@hotmail.com	$2b$12$7EHTZeptIdtRRqFvX2BUkul0GDfxUPqEruZ7ua72C9TrJD9jPIyJS	2026-06-03 21:38:05.753577	sara	797ee556-2f70-44f1-9994-f6ace4a36e9d	f	\N	\N	2026-06-03 21:38:05.753577	\N	\N	\N	\N	\N	\N	2564408084adb7a068a8f6bd81987bc248ebd15f3300589111d96526a9172aba	2026-06-04 21:38:05.753	f	\N	\N
39446f2f-aefa-49a1-be5a-f8b2ad4df198	sebi.saliger@outlook.de	$2b$12$E7TkUPDrRR2P7wXvugIZ3uN9Fe7eq8UvrV4bGWkB0D8LNLP/TjyWu	2026-06-03 15:15:35.234497	sebi	797ee556-2f70-44f1-9994-f6ace4a36e9d	t			2026-06-03 15:15:35.234497	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N
1d5b97e7-c661-4d24-9114-1784f7004a53	hey@test.com	$2b$12$zvJKSxim4teSJmhT0lFw8eiHQWkTjCRD2Es5J/Rc0oGg0ojtBELYm	2026-05-30 10:26:40.227815	hey	797ee556-2f70-44f1-9994-f6ace4a36e9d	f		Cardiology	2026-05-30 10:26:40.227815	\N	\N	\N	\N	\N	/uploads/1d5b97e7-c661-4d24-9114-1784f7004a53-1780431622398.jpg	\N	\N	f	\N	\N
f596c56d-6c6c-4e24-8740-28f914d05e3e	admin@medChat.com	$2b$12$LLMlg/iAKcyyD/GSLWBSe.LFbBzRT8aDTmSAfgkVx65lEYAso3n1y	2026-05-30 10:32:08.783289	admin	49495b76-c4fd-4caa-b323-2decb56c8ba6	f	/private/documents/f596c56d-6c6c-4e24-8740-28f914d05e3e-1780605709951.pdf		2026-06-04 20:41:49.959			\N			/uploads/f596c56d-6c6c-4e24-8740-28f914d05e3e-1780349459842.jpg	\N	\N	f	\N	\N
b230d296-db77-4ddf-820c-bc3b6f7dc7e5	test@123214.com	$2b$12$nIqS3ZUh56LOq4IfGyQKvewePgwJFfOOdd69.3T10mV4bLnc1lHmu	2026-06-03 17:53:39.996127	asdfasdf	797ee556-2f70-44f1-9994-f6ace4a36e9d	f	\N	\N	2026-06-03 17:53:39.996127	\N	\N	\N	\N	\N	\N	937eecb6c662f1b7a72167ae79aabb93fdbeca4e2baa46630c725fbd8f24298d	2026-06-04 17:53:39.995	f	\N	\N
1e9e130c-68ec-4959-abe2-598853a13ba9	1234@1234.com	$2b$12$Zb4kHLNw13SvsdAWUvPrW.8ZMoxeyyLQXQ3JmolOflAcRg.SzVEPu	2026-06-03 21:17:59.516498	1123	797ee556-2f70-44f1-9994-f6ace4a36e9d	f	\N	\N	2026-06-03 21:17:59.516498	\N	\N	\N	\N	\N	\N	c407173055e52a429588933f16aad730742f12016a7930886d264a397ac27e38	2026-06-04 21:17:59.516	f	\N	\N
\.


--
-- Name: __drizzle_migrations_id_seq; Type: SEQUENCE SET; Schema: drizzle; Owner: medchat
--

SELECT pg_catalog.setval('drizzle.__drizzle_migrations_id_seq', 1, false);


--
-- Name: __drizzle_migrations __drizzle_migrations_pkey; Type: CONSTRAINT; Schema: drizzle; Owner: medchat
--

ALTER TABLE ONLY drizzle.__drizzle_migrations
    ADD CONSTRAINT __drizzle_migrations_pkey PRIMARY KEY (id);


--
-- Name: categories categories_name_unique; Type: CONSTRAINT; Schema: public; Owner: medchat
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_name_unique UNIQUE (name);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: medchat
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: posts posts_pkey; Type: CONSTRAINT; Schema: public; Owner: medchat
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);


--
-- Name: roles roles_name_unique; Type: CONSTRAINT; Schema: public; Owner: medchat
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_name_unique UNIQUE (name);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: medchat
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: topics topics_pkey; Type: CONSTRAINT; Schema: public; Owner: medchat
--

ALTER TABLE ONLY public.topics
    ADD CONSTRAINT topics_pkey PRIMARY KEY (id);


--
-- Name: users users_email_unique; Type: CONSTRAINT; Schema: public; Owner: medchat
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_unique UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: medchat
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_unique; Type: CONSTRAINT; Schema: public; Owner: medchat
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_unique UNIQUE (username);


--
-- Name: posts posts_topic_id_topics_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: medchat
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_topic_id_topics_id_fk FOREIGN KEY (topic_id) REFERENCES public.topics(id);


--
-- Name: posts posts_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: medchat
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: topics topics_category_id_categories_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: medchat
--

ALTER TABLE ONLY public.topics
    ADD CONSTRAINT topics_category_id_categories_id_fk FOREIGN KEY (category_id) REFERENCES public.categories(id);


--
-- Name: topics topics_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: medchat
--

ALTER TABLE ONLY public.topics
    ADD CONSTRAINT topics_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: users users_document_verified_by_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: medchat
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_document_verified_by_users_id_fk FOREIGN KEY (document_verified_by) REFERENCES public.users(id);


--
-- Name: users users_role_id_roles_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: medchat
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_role_id_roles_id_fk FOREIGN KEY (role_id) REFERENCES public.roles(id);


--
-- PostgreSQL database dump complete
--

\unrestrict KUsQIunh1toLTyEashQGHBh0MYmQdd9V4hJH2yv5yagrObZCpcVqtwQSobJBQzF

