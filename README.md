# Windows Network Security Auditor

## Overview
This project provides a professional methodology for auditing and hardening Windows Firewall configurations. It shifts from manual UI-based configuration to an analytical, script-driven approach, essential for SysAdmin environments where consistency and auditability are critical.

## The Problem
During network security hardening, we often encounter a "Rule Shadowing" issue:
- Manual `Block` rules (port-based) are often overridden by existing `Allow` rules (application-based, like those created by XAMPP or installer packages).
- Traditional UI tools (Windows Firewall Console) mask these conflicts, making it difficult to verify if a port is actually secured.

## Methodology
1. **Context Analysis**: Utilizing native PowerShell modules (`NetSecurity`) to map firewall hierarchy.
2. **Conflict Resolution**: Identifying and disabling permissive application-level rules that conflict with socket-level security.
3. **Verification**: Using `Test-NetConnection` to validate that the security policy effectively drops traffic from network interfaces, moving beyond the unreliable `localhost` loopback test.

## How to use
1. Open PowerShell as **Administrator**.
2. Run the audit script:
   `.\Audit-NetworkPolicy.ps1 -Port 8080`
3. Validate the results against your expected security posture.

## Key Learnings
- **Rule Precedence**: Process-level rules take precedence over port-level restrictions.
- **Socket State**: Closing a rule does not terminate established socket connections; processes must be cycled for policy enforcement.