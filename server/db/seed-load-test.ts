import { drizzle } from "drizzle-orm/postgres-js";
import postgres from "postgres";
import { topics, categories, users, posts } from "./schema";

// Erzeugt eine große Menge an Dummy-Topics inkl. zugehöriger Posts mit
// vorhandenen Usern/Kategorien, um realistische Datenmengen für einen
// Lasttest zu erzeugen (z. B. gegen /api/topics und /api/posts).
//
// Nutzung:
//   npx tsx --env-file=.env server/db/seed-load-test.ts
//
// Anzahl Topics anpassen:
//   SEED_TOPIC_COUNT=5000 npx tsx --env-file=.env server/db/seed-load-test.ts
//
// Anzahl Posts pro Topic anpassen (Standard: 0-5 zufällig):
//   SEED_MAX_POSTS_PER_TOPIC=10 npx tsx --env-file=.env server/db/seed-load-test.ts

const TOPIC_COUNT = Number(process.env.SEED_TOPIC_COUNT ?? 2000);
const MAX_POSTS_PER_TOPIC = Number(process.env.SEED_MAX_POSTS_PER_TOPIC ?? 5);

const client = postgres(process.env.DATABASE_URL!);
const db = drizzle(client);

const sampleTitles = [
  "Frage zu Differentialdiagnose bei unklarem Fieber",
  "Erfahrungen mit neuem Therapieschema",
  "Wie geht ihr mit Komplikationen nach Eingriff X um?",
  "Leitlinienänderung 2026 – Diskussion",
  "Fallbeispiel: ungewöhnlicher Verlauf bei Patient",
  "Medikamenteninteraktion – wer kennt sich aus?",
  "Erfahrungsaustausch zu neuer Diagnosetechnik",
  "Wie dokumentiert ihr X in eurer Klinik?",
  "Frage zur Dosierung bei Niereninsuffizienz",
  "Diskussion: Sinnvolle Nachsorge nach Behandlung Y",
];

const samplePostContents = [
  "Aus meiner Erfahrung würde ich hier eher konservativ vorgehen, abhängig vom klinischen Gesamtbild.",
  "Guter Punkt. Wir handhaben das in unserer Klinik ähnlich, mit etwas angepasster Dosierung.",
  "Hier wäre eine erweiterte Diagnostik sinnvoll, bevor man sich festlegt.",
  "Kann ich aus eigener Erfahrung bestätigen, hatten kürzlich einen vergleichbaren Fall.",
  "Die aktuelle Leitlinie empfiehlt hier ein abgestuftes Vorgehen, siehe entsprechende Quelle.",
  "Interessanter Fall – wie war der weitere Verlauf nach der ersten Intervention?",
  "Wir nutzen dafür ein standardisiertes Protokoll, das sich in der Praxis bewährt hat.",
  "Das deckt sich mit den Beobachtungen aus unserer Abteilung.",
];

function randomFrom<T>(arr: T[]): T {
  return arr[Math.floor(Math.random() * arr.length)];
}

function randomInt(min: number, max: number): number {
  return Math.floor(Math.random() * (max - min + 1)) + min;
}

async function seedLoadTestData() {
  const allCategories = await db.select().from(categories);
  const allUsers = await db.select().from(users);

  if (allCategories.length === 0 || allUsers.length === 0) {
    console.error("Keine Kategorien oder Nutzer in der Datenbank gefunden.");
    await client.end();
    process.exit(1);
  }

  console.log(
    `Erzeuge ${TOPIC_COUNT} Topics (mit bis zu ${MAX_POSTS_PER_TOPIC} Posts je Topic) mit ${allUsers.length} vorhandenen Usern...`
  );

  const batchSize = 200;
  let totalPosts = 0;

  for (let i = 0; i < TOPIC_COUNT; i += batchSize) {
    const currentBatchSize = Math.min(batchSize, TOPIC_COUNT - i);

    const topicBatch = Array.from({ length: currentBatchSize }, (_, j) => ({
      title: `${randomFrom(sampleTitles)} #${i + j + 1}`,
      description: `Generiertes Thema für Lasttest (Eintrag ${i + j + 1}).`,
      userId: randomFrom(allUsers).id,
      categoryId: randomFrom(allCategories).id,
      isResolved: Math.random() > 0.5,
    }));

    const insertedTopics = await db.insert(topics).values(topicBatch).returning({
      id: topics.id,
    });

    // Zu jedem neu erzeugten Topic eine zufällige Anzahl Posts anlegen
    const postBatch: (typeof posts.$inferInsert)[] = [];
    for (const topic of insertedTopics) {
      const postCount = randomInt(0, MAX_POSTS_PER_TOPIC);
      for (let p = 0; p < postCount; p++) {
        postBatch.push({
          content: randomFrom(samplePostContents),
          userId: randomFrom(allUsers).id,
          topicId: topic.id,
        });
      }
    }

    if (postBatch.length > 0) {
      await db.insert(posts).values(postBatch);
      totalPosts += postBatch.length;
    }

    console.log(
      `  ${Math.min(i + batchSize, TOPIC_COUNT)} / ${TOPIC_COUNT} Topics, ${totalPosts} Posts bisher`
    );
  }

  console.log(`Fertig. ${TOPIC_COUNT} Topics und ${totalPosts} Posts erzeugt.`);
  await client.end();
}

seedLoadTestData().catch((err) => {
  console.error(err);
  process.exit(1);
});
