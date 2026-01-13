# Global Claude Code Instructions

## Document Reading Policy

For large documents (PDF, Excel, Word, PPT), use the Task tool with
subagent_type="Explore" to read and summarize. Return only key
information to the main context. Do NOT load full document content
directly with the Read tool.
