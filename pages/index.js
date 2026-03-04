import Head from "next/head";

export default function Home() {
  return (
    <>
      <Head>
        <title>Security Agent Testbed</title>
        <meta name="description" content="A testbed for security agent testing" />
      </Head>
      <main style={{ padding: "2rem", fontFamily: "system-ui, sans-serif" }}>
        <h1>Security Agent Testbed</h1>
        <p>
          This project contains intentionally vulnerable dependencies for
          testing security tooling.
        </p>
        <p>
          Run <code>npm audit</code> to see the list of known vulnerabilities.
        </p>
      </main>
    </>
  );
}
