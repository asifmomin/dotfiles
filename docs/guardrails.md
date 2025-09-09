# Guardrails & Constraints

This document establishes the principles, constraints, and guardrails that guide decision-making for this dotfiles system to maintain its quality, simplicity, and alignment with Omarchy's philosophy.

## Core Constraints

### 1. Omarchy Philosophy Preservation

**Constraint**: All changes must respect and preserve Omarchy's minimal approach.

**Guidelines**:
- **Before adding**: Ask "Would this fit in Omarchy?"
- **Prefer simplicity**: Choose simple solutions over complex ones
- **Trust defaults**: Use tool defaults rather than extensive customization
- **Performance first**: Avoid features that slow startup or operation
- **Essential only**: Include only widely-needed functionality

**Violation Examples**:
- ❌ Complex custom Neovim configurations
- ❌ Extensive shell prompt customizations
- ❌ Tool-specific optimizations that break simplicity
- ❌ Features that duplicate existing tool functionality

**Acceptable Examples**:
- ✅ Tokyo Night theme application (visual consistency)
- ✅ XDG compliance (modern file organization)
- ✅ Cross-platform support (practical necessity)
- ✅ Basic tool integration (aliases, functions)

### 2. Cross-Platform Compatibility

**Constraint**: All features must work identically across macOS, Linux, and WSL.

**Requirements**:
- **Single package manager**: Homebrew only
- **Platform detection**: Automated platform-specific behavior
- **Consistent APIs**: Same commands work everywhere
- **No platform-specific configs**: Conditional blocks only

**Testing Requirements**:
- Every feature tested on all three platforms
- Bootstrap process verified on fresh installations
- Platform-specific code clearly documented

### 3. Security Standards

**Constraint**: Security must be built-in, not bolted-on.

**Non-Negotiables**:
- **No plaintext secrets**: All secrets encrypted with SOPS + age
- **Proper permissions**: Restrictive file permissions by default
- **No key sharing**: Each user generates own encryption keys
- **Audit trail**: All changes tracked in version control

**Security Review Requirements**:
- All new features reviewed for security implications
- Default configurations must be secure
- Documentation must include security considerations
- Regular security updates for dependencies

### 4. Minimal Configuration Principle

**Constraint**: Prefer tool defaults over custom configurations.

**Rules**:
- **Justify customization**: Every custom setting must have clear rationale
- **Document decisions**: Why we override defaults
- **Regular review**: Periodically review customizations for continued necessity
- **Upstream first**: Contribute improvements to upstream tools when possible

**Configuration Hierarchy**:
1. Tool defaults (preferred)
2. Essential changes only (Tokyo Night theme, XDG compliance)
3. Minimal customization (performance, security)
4. User overrides (local configs)

## Feature Addition Guidelines

### 1. Tool Inclusion Criteria

**Required Criteria** (all must be met):
- [ ] **Wide adoption**: Used by significant portion of developers
- [ ] **Cross-platform**: Available on macOS, Linux, WSL
- [ ] **Active maintenance**: Regularly updated and maintained
- [ ] **Stable API**: Consistent configuration interface
- [ ] **Performance**: Doesn't significantly impact startup time

**Evaluation Criteria** (most should be met):
- [ ] **Replaces core tool**: Better alternative to standard tool (e.g., `bat` vs `cat`)
- [ ] **Development focused**: Primarily for software development
- [ ] **Terminal-based**: Works in terminal environment
- [ ] **Team-friendly**: Supports collaboration workflows
- [ ] **Documentation**: Well-documented with examples

**Disqualification Criteria** (any disqualifies):
- [ ] **GUI-only**: Requires graphical interface
- [ ] **Language-specific**: Only useful for specific programming languages
- [ ] **Niche use case**: Solves problems for < 20% of developers
- [ ] **Unstable**: Frequent breaking changes
- [ ] **Security concerns**: Known security issues

### 2. Configuration Addition Process

**Step 1: Justification**
```
Tool: [tool name]
Problem: [what problem does this solve?]
Alternatives: [what alternatives were considered?]
Rationale: [why is this the best solution?]
```

**Step 2: Implementation**
- Create minimal configuration
- Follow existing patterns
- Include comprehensive documentation
- Add to Brewfile and justfile

**Step 3: Testing**
- Test on all three platforms
- Verify bootstrap process
- Check performance impact
- Document any issues

**Step 4: Review**
- Code review for quality
- Documentation review for completeness
- Security review for implications
- Performance review for impact

### 3. Change Impact Assessment

**Breaking Changes** (require major version bump):
- Changes that break existing workflows
- Removal of existing features
- Configuration file format changes
- Command interface changes

**Minor Changes** (require minor version bump):
- New features that don't break existing functionality
- Additional tools or configurations
- Enhanced documentation
- Performance improvements

**Patch Changes** (patch version bump):
- Bug fixes
- Documentation corrections
- Security updates
- Minor tweaks

## Quality Standards

### 1. Code Quality

**Shell Scripts**:
- Use `set -euo pipefail` for error handling
- Quote all variables
- Use meaningful variable names
- Include error checking
- Follow ShellCheck recommendations

**Configuration Files**:
- Consistent formatting and indentation
- Clear comments explaining non-obvious settings
- Logical organization
- No hardcoded paths or values

**Documentation**:
- Clear, concise writing
- Working examples for all features
- Regular updates with code changes
- Cross-references between related docs

### 2. Testing Standards

**Required Testing**:
- Bootstrap process on clean systems
- All justfile commands work correctly
- Cross-platform compatibility verified
- No broken symlinks after stow operations

**Test Environments**:
- macOS with Homebrew
- Ubuntu with Homebrew on Linux
- WSL Ubuntu with Homebrew

**Performance Testing**:
- Shell startup time < 200ms
- Tool response time acceptable
- No memory leaks or resource issues

### 3. Documentation Standards

**Required Documentation**:
- README with quick start guide
- Installation instructions
- Configuration examples
- Troubleshooting guide
- Change log

**Documentation Quality**:
- Examples that work out of the box
- Clear explanations for beginners
- Advanced usage for experts
- Regular updates and reviews

## Maintenance Guardrails

### 1. Dependency Management

**Homebrew Formula Selection**:
- Prefer official formulas over third-party taps
- Avoid formulas with many dependencies
- Monitor for deprecated or unmaintained formulas
- Regular updates and security patches

**Version Pinning Policy**:
- Generally avoid version pinning
- Pin only when necessary for stability
- Document reasons for pinning
- Regular review of pinned versions

### 2. Technical Debt Management

**Code Review Requirements**:
- All changes require review
- Focus on maintainability
- Check for technical debt accumulation
- Ensure consistent patterns

**Refactoring Schedule**:
- Quarterly review of configurations
- Annual review of tool selections
- Regular cleanup of deprecated features
- Performance optimization reviews

### 3. User Support

**Issue Response Time**:
- Acknowledge issues within 48 hours
- Provide initial response within 1 week
- Security issues addressed immediately
- Regular triage of open issues

**Support Boundaries**:
- Support official configurations only
- Direct users to tool documentation for tool-specific issues
- Provide examples but not custom solutions
- Focus on common use cases

## Evolution Principles

### 1. Backwards Compatibility

**Compatibility Promise**:
- Configuration files remain compatible within major versions
- Command interfaces stable within major versions
- Migration guides for breaking changes
- Deprecation warnings before removal

**Change Process**:
- Announce breaking changes in advance
- Provide migration tools when possible
- Maintain old and new approaches during transition
- Clear documentation of changes

### 2. Community Input

**Feedback Channels**:
- GitHub issues for bugs and feature requests
- Documentation for common questions
- Regular review of user feedback
- Community polls for major decisions

**Decision Making**:
- Maintainer has final decision authority
- Community input heavily weighted
- Transparency in decision rationale
- Regular communication of direction

### 3. Long-term Sustainability

**Maintenance Approach**:
- Conservative approach to new features
- Focus on stability over novelty
- Regular maintenance releases
- Clear succession planning

**Resource Management**:
- Scope creep prevention
- Maintainer time protection
- Community contribution encouragement
- Sustainable development pace

## Violation Response

### 1. Principle Violations

**Assessment Process**:
1. Identify the violated principle
2. Assess impact on system quality
3. Determine corrective action needed
4. Implement fix with priority based on severity

**Severity Levels**:
- **Critical**: Security issues, data loss risk
- **High**: Breaks core functionality
- **Medium**: Violates design principles
- **Low**: Minor inconsistencies

### 2. Quality Issues

**Code Quality Issues**:
- Immediate fix for security problems
- Scheduled fix for performance issues
- Regular cleanup for style issues
- Documentation updates for clarity issues

**Process Issues**:
- Review and update processes as needed
- Additional training or tools if helpful
- Clear communication of expectations
- Regular process improvement

## Conclusion

These guardrails ensure that the dotfiles system maintains its quality, simplicity, and alignment with Omarchy's philosophy while serving modern development needs. They provide clear criteria for decision-making and help maintain consistency across all aspects of the system.

The goal is not to prevent all change but to ensure that changes are thoughtful, beneficial, and aligned with the system's core values. By following these guardrails, we can evolve the system responsibly while preserving what makes it valuable.