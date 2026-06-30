# Global Claude Code Instructions

## Document Reading Policy

For large documents (PDF, Excel, Word, PPT), use the Task tool with
subagent_type="Explore" to read and summarize. Return only key
information to the main context. Do NOT load full document content
directly with the Read tool.

## Document Handling

When asked to 'store' or 'save' a document, write it to a file immediately
without implementing or executing any plans within it.

## Working Style

When given a task, present a short plan (numbered steps, affected files) first.
Do NOT write code or make file changes until the user explicitly says "go",
"implement", "do it", or similar. The user often wants a plan, TODO doc, or
discussion — not immediate implementation.

Keep responses concise. Use bullet points and tables, not paragraphs.
The user will ask for detail when needed.
