import { drizzle } from "drizzle-orm/postgres-js";
import postgres from "postgres";
import { categories, topics, posts } from "./schema";
import { eq } from "drizzle-orm";

const client = postgres(process.env.DATABASE_URL!);
const db = drizzle(client);

const USER_1 = "516b828d-625c-4136-8227-3d48e50c7b7e"; // drumdidam
const USER_2 = "20262d95-4474-4b89-b0fa-37060455a794"; // hallo

const medicalCategories = [
  { name: "Internal Medicine", description: "Diagnosis and treatment of diseases affecting internal organs such as the heart, lungs, kidneys and gastrointestinal tract" },
  { name: "Surgery", description: "Operative treatment of injuries, diseases and malformations" },
  { name: "Neurology", description: "Diseases of the brain, spinal cord and peripheral nervous system" },
  { name: "Cardiology", description: "Diagnosis and therapy of heart diseases and vascular conditions" },
  { name: "Orthopedics & Trauma Surgery", description: "Diseases and injuries of the musculoskeletal system – bones, joints, muscles and ligaments" },
  { name: "Pediatrics", description: "Medical care of infants, children and adolescents" },
  { name: "Psychiatry & Psychosomatics", description: "Mental illnesses, behavioral disorders and psychosomatic conditions" },
  { name: "Gynecology & Obstetrics", description: "Diseases of the female reproductive system as well as pregnancy, childbirth and postpartum care" },
  { name: "Dermatology", description: "Diseases of the skin, hair and nails as well as allergological conditions" },
  { name: "Radiology", description: "Diagnostic imaging and interventional procedures using X-ray, CT, MRI and ultrasound" },
  { name: "Anesthesiology & Intensive Care", description: "Anesthesia, pain management and intensive care treatment of critically ill patients" },
  { name: "Urology", description: "Diseases of the urinary tract and male reproductive organs" },
  { name: "Ophthalmology", description: "Diseases of the eye and visual pathway" },
  { name: "ENT (Ear, Nose & Throat)", description: "Diseases of the throat, nose, ears as well as swallowing and voice disorders" },
  { name: "Emergency Medicine", description: "Acute care of life-threatening conditions and pre-hospital emergency medicine" },
];

const dummyTopics: {
  title: string;
  description: string;
  categoryName: string;
  userId: string;
  isResolved: boolean;
  posts: { content: string; userId: string }[];
}[] = [
  {
    title: "Troponin elevation after TAVI – how to interpret?",
    description: "Patient had TAVI yesterday, troponin is now 8x ULN. Hemodynamically stable. Is this expected post-procedural release or should we be worried?",
    categoryName: "Cardiology",
    userId: USER_1,
    isResolved: true,
    posts: [
      { content: "Post-TAVI troponin elevation is very common and usually reflects myocardial injury from the procedure itself. An 8x ULN rise in a hemodynamically stable patient is within what we typically see. I'd follow serial ECGs and echo at 24h to rule out new WMA.", userId: USER_2 },
      { content: "Agreed. The key question is trajectory — is it peaking and coming down? Also worth checking if the patient had any periprocedural complications like coronary occlusion. If echo looks fine and patient is stable, watchful waiting is appropriate.", userId: USER_1 },
    ],
  },
  {
    title: "Best approach for acute appendicitis in pregnancy (2nd trimester)?",
    description: "28-year-old at 20 weeks gestation presenting with RLQ pain, low-grade fever, leukocytosis. Ultrasound inconclusive. MRI ordered but 6h wait. How aggressive should we be?",
    categoryName: "Surgery",
    userId: USER_2,
    isResolved: false,
    posts: [
      { content: "MRI is the gold standard here and worth the wait if the patient is stable. Don't delay if she deteriorates. Laparoscopic appendectomy in the 2nd trimester is well-tolerated — open port placement slightly higher than usual to account for the uterus.", userId: USER_1 },
      { content: "Surgeon here — we'd proceed with MRI if feasible. If she spikes a fever or peritoneal signs develop before imaging, take her to OR. The risk of perforated appendicitis to the fetus is far greater than the surgical risk.", userId: USER_2 },
    ],
  },
  {
    title: "Migraine vs. thunderclap headache – red flags in the ED?",
    description: "23F with known migraine history presenting with 'worst headache of my life'. Has had similar before. How do you decide whether to LP?",
    categoryName: "Neurology",
    userId: USER_1,
    isResolved: true,
    posts: [
      { content: "The phrase 'worst headache of my life' with thunderclap onset mandates LP or CTA regardless of migraine history. CT sensitivity for SAH drops after 6h. Don't anchor on the migraine history.", userId: USER_2 },
      { content: "Ottawa SAH rule is useful here — if onset was truly sudden and maximal at onset, LP is warranted even with negative CT. Xanthochromia in CSF is your answer.", userId: USER_1 },
      { content: "One caveat: if CT was within 6h and is negative, sensitivity for SAH is ~98%. Some centers skip LP in that scenario. Discuss with neurology and document the shared decision.", userId: USER_2 },
    ],
  },
  {
    title: "Pediatric fever without source – when to do a septic workup?",
    description: "9-month-old, 39.8°C, no focus found. Vaccinated. Well-appearing. Parents anxious. What's your threshold for blood culture, urine, LP?",
    categoryName: "Pediatrics",
    userId: USER_2,
    isResolved: false,
    posts: [
      { content: "At 9 months and fully vaccinated, the risk of occult bacteremia is very low. For a well-appearing child I'd do a UA/urine culture (UTI is still the main concern in this age group) and reassess. I wouldn't reflexively LP a well-looking vaccinated infant.", userId: USER_1 },
      { content: "Agree on urine. Use the Rochester or Philadelphia criteria if you're on the fence. If the child is well-appearing and you can ensure solid follow-up, a watchful waiting approach with clear return precautions is reasonable.", userId: USER_2 },
    ],
  },
  {
    title: "Managing acute psychosis – haloperidol vs. olanzapine in the ED?",
    description: "35M brought in by police, severely agitated, unknown psychiatric history. Which antipsychotic do you reach for first and at what dose?",
    categoryName: "Psychiatry & Psychosomatics",
    userId: USER_1,
    isResolved: false,
    posts: [
      { content: "For acute agitation I typically use droperidol or haloperidol IM — fast onset, reliable. Olanzapine IM is also effective but avoid combining it with benzodiazepines due to respiratory depression risk. Get an ECG if you can.", userId: USER_2 },
      { content: "Our ED protocol uses haloperidol 5mg + lorazepam 2mg IM (B52). For excited delirium or if substance use is suspected, ketamine IM is increasingly used for rapid control. Always have resuscitation equipment ready.", userId: USER_1 },
    ],
  },
  {
    title: "Ectopic pregnancy – expectant management criteria?",
    description: "hCG 1200, transvaginal ultrasound shows empty uterus with small adnexal mass. Hemodynamically stable, no free fluid. Methotrexate vs. expectant?",
    categoryName: "Gynecology & Obstetrics",
    userId: USER_2,
    isResolved: true,
    posts: [
      { content: "With hCG under 1500 and a small adnexal mass, expectant management is a valid option if the patient is compliant and you have reliable follow-up. Repeat hCG in 48h — if it drops >15%, continue watching. MTX if it plateaus or rises.", userId: USER_1 },
      { content: "I'd lean toward MTX here — single dose is well-tolerated and avoids the uncertainty of expectant management. Make sure there are no contraindications (renal/liver function, blood count). Counsel about the ectopic rupture risk even post-MTX.", userId: USER_2 },
    ],
  },
  {
    title: "Differentiating cellulitis from DVT with leg swelling",
    description: "Patient with unilateral leg swelling, erythema, warmth, and tenderness. D-dimer elevated. Wells score 2. Do you treat for both empirically while waiting for duplex?",
    categoryName: "Internal Medicine",
    userId: USER_1,
    isResolved: false,
    posts: [
      { content: "Classic dilemma. Cellulitis typically has a clear leading edge, fever, and systemic signs. DVT can look very similar. With a Wells score of 2 and elevated D-dimer, duplex is mandatory — don't delay it. I wouldn't start anticoagulation empirically before imaging unless the wait is >24h.", userId: USER_2 },
      { content: "If imaging is delayed and clinical suspicion for DVT is high, anticoagulation is reasonable. Antibiotics won't hurt if cellulitis coexists. Mark the erythema border with a skin marker to track progression.", userId: USER_1 },
    ],
  },
  {
    title: "Typical rash in a 6-year-old – slapped cheek vs. rubella?",
    description: "Child presenting with bright red facial rash spreading to trunk, low-grade fever 2 days prior, now afebrile. No vaccination records available.",
    categoryName: "Dermatology",
    userId: USER_2,
    isResolved: true,
    posts: [
      { content: "This sounds like classic erythema infectiosum (fifth disease / parvovirus B19). The slapped cheek appearance followed by a lacy reticular rash on the trunk is pathognomonic. Management is supportive. Key point: patient is no longer infectious once the rash appears.", userId: USER_1 },
      { content: "Rubella would present with Forchheimer spots (petechiae on soft palate), lymphadenopathy, and a more diffuse maculopapular rash. With no vaccination record, serology can confirm — important especially if there's contact with pregnant women.", userId: USER_2 },
    ],
  },
  {
    title: "Interpreting incidental adrenal adenoma on CT – next steps?",
    description: "CT abdomen for unrelated reason found a 2.1cm left adrenal mass with 15 HU density. Patient asymptomatic, normotensive.",
    categoryName: "Radiology",
    userId: USER_1,
    isResolved: false,
    posts: [
      { content: "A density of 15 HU is above the 10 HU threshold for lipid-rich adenoma. You'd want a dedicated adrenal protocol CT with washout values. If absolute washout >60% or relative >40%, adenoma is confirmed. Also check bloods: metanephrines, aldosterone/renin ratio, cortisol suppression test.", userId: USER_2 },
      { content: "The endocrine workup is mandatory regardless of imaging — you need to rule out pheo before any intervention or anesthesia. Size <4cm with benign imaging features and negative biochemistry = follow-up imaging at 6–12 months.", userId: USER_1 },
    ],
  },
  {
    title: "RSI drug choice in head trauma patient – succinylcholine safe?",
    description: "GCS 8 after MVC, suspected TBI, no C-spine cleared. Need to intubate. Concern about ICP rise with succinylcholine?",
    categoryName: "Anesthesiology & Intensive Care",
    userId: USER_2,
    isResolved: true,
    posts: [
      { content: "The ICP concern with succinylcholine is largely theoretical — the fasciculations may transiently raise ICP but the clinical significance in most TBI patients is minimal. The rapid onset and offset are valuable if you need to reassess neuro status. Rocuronium at 1.2mg/kg is a solid alternative with sugammadex available.", userId: USER_1 },
      { content: "We use rocuronium + ketamine for most trauma RSIs now. Ketamine's ICP effects have been largely debunked and its cardiovascular stability is useful in hypotensive trauma patients. Avoid etomidate if adrenal suppression is a concern.", userId: USER_2 },
    ],
  },
];

async function seed() {
  console.log("Seeding categories...");
  for (const category of medicalCategories) {
    await db.insert(categories).values(category).onConflictDoNothing();
  }

  const allCategories = await db.select().from(categories);
  const categoryMap = Object.fromEntries(allCategories.map((c) => [c.name, c.id]));

  // Fix existing topics that have no category
  console.log("Assigning categories to existing topics...");
  await db
    .update(topics)
    .set({ categoryId: categoryMap["Cardiology"] })
    .where(eq(topics.title, "Cardiology"));
  await db
    .update(topics)
    .set({ categoryId: categoryMap["Dermatology"] })
    .where(eq(topics.title, "Dermatology"));

  console.log("Seeding dummy topics and posts...");
  for (const topicData of dummyTopics) {
    const categoryId = categoryMap[topicData.categoryName];

    const [insertedTopic] = await db
      .insert(topics)
      .values({
        title: topicData.title,
        description: topicData.description,
        userId: topicData.userId,
        categoryId,
        isResolved: topicData.isResolved,
      })
      .returning();

    for (const post of topicData.posts) {
      await db.insert(posts).values({
        content: post.content,
        userId: post.userId,
        topicId: insertedTopic.id,
      });
    }
  }

  console.log(`Done. ${dummyTopics.length} topics with posts created.`);
  await client.end();
}

seed().catch((err) => {
  console.error(err);
  process.exit(1);
});
