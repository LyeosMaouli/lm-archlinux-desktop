# Fix Implementation Plan

## Phase 1: Critical Fixes (Must Fix Before Use)

### Fix 1: Create Missing bootstrap.conf
**Priority**: CRITICAL  
**File**: `/bootstrap.conf`  
**Action**: Copy `example_bootstrap.conf` to `bootstrap.conf` with appropriate defaults

```bash
cp example_bootstrap.conf bootstrap.conf
# Update with sensible defaults
```

### Fix 2: Remove Hardcoded Username from Main Playbook
**Priority**: CRITICAL  
**File**: `local.yml`  
**Action**: Replace hardcoded "lyeosmaouli" with configurable variable

**Changes needed**:
- Line 13: `"Enter password for user '{{ main_user }}'"` 
- Line 50: Use variable instead of hardcoded name
- Line 78: Update completion message to use variable

### Fix 3: Fix CONFIG_DIR Path
**Priority**: CRITICAL  
**File**: `scripts/internal/common.sh:14`  
**Action**: Update CONFIG_DIR path

```bash
# Change from:
readonly CONFIG_DIR="$PROJECT_ROOT/config"
# To:
readonly CONFIG_DIR="$PROJECT_ROOT/deploy-config"
```

### Fix 4: Replace Placeholder Values
**Priority**: CRITICAL  
**File**: `deploy-config/deploy.conf`  
**Action**: Replace placeholder values with sensible defaults

```bash
# Line 18: USER_NAME="username_placeholder" -> USER_NAME="user"
# Line 34: HOSTNAME="hostname_placeholder" -> HOSTNAME="arch-desktop"
```

## Phase 2: Important Configuration Fixes

### Fix 5: Standardize Default Locale Settings
**Priority**: HIGH  
**Files**: 
- `configs/ansible/roles/base_system/defaults/main.yml`
- `deploy-config/deploy.conf`

**Action**: Change French defaults to neutral defaults
- Keymap: "fr" → "us"
- Timezone: "Europe/Paris" → "UTC"
- Mirror country: "United Kingdom" → Auto-detect or "Global"

### Fix 6: Fix Git Configuration Template
**Priority**: HIGH  
**File**: `deploy-config/deploy.conf:226-227`  
**Action**: Make git configuration optional or provide clear instructions

```bash
# Add comment explaining these should be customized
# Git configuration - Customize before deployment
# Leave empty to skip git configuration
GIT_USERNAME=""  # Change to your name
GIT_EMAIL=""     # Change to your email
```

### Fix 7: Standardize Variable References
**Priority**: HIGH  
**Files**: All configuration templates  
**Action**: Ensure consistent variable naming and referencing

## Phase 3: Structural Improvements

### Fix 8: Standardize Project Root Detection
**Priority**: MEDIUM  
**Files**: All scripts using project root detection  
**Action**: Use consistent method from common.sh

### Fix 9: Standardize Log File Locations
**Priority**: MEDIUM  
**Files**: All scripts with logging  
**Action**: Use LOG_DIR and LOG_FILE from common.sh

### Fix 10: Add File Permission Settings
**Priority**: MEDIUM  
**Files**: Scripts creating sensitive files  
**Action**: Add explicit chmod commands for security-sensitive files

## Phase 4: Documentation Updates

### Fix 11: Update CLAUDE.md References
**Priority**: LOW  
**File**: `CLAUDE.md`  
**Action**: Ensure all file references match actual project structure

### Fix 12: Update Installation Documentation
**Priority**: LOW  
**Files**: All documentation in `docs/`  
**Action**: Verify all commands and paths are correct

## Implementation Order

1. **Immediate Critical Fixes (Phase 1)**:
   - Create bootstrap.conf
   - Fix hardcoded username
   - Fix CONFIG_DIR path
   - Replace placeholder values

2. **Configuration Standardization (Phase 2)**:
   - Update default locales
   - Fix git configuration
   - Standardize variables

3. **Code Quality (Phase 3)**:
   - Structural improvements
   - Consistent patterns

4. **Documentation (Phase 4)**:
   - Update references
   - Verify accuracy

## Testing Plan

After each phase:
1. Run syntax validation on all modified files
2. Test deployment in VirtualBox
3. Verify configuration loading works
4. Check that scripts execute without errors

## Risk Assessment

**Low Risk Fixes**:
- Documentation updates
- Default value changes
- Comments and instructions

**Medium Risk Fixes**:
- Configuration path changes
- Variable name changes

**High Risk Fixes**:
- Main playbook modifications
- Core script changes

## Success Criteria

- [ ] All scripts load configuration without errors
- [ ] Bootstrap deployment works with default configuration
- [ ] Username and hostname are properly configurable
- [ ] No hardcoded values in critical paths
- [ ] Consistent configuration format across all files