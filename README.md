# eco-ci-cd Build Utilities

This repository contains build utilities and automation tools for the
[eco-ci-cd](https://github.com/openshift-kni/eco-ci-cd) project.
These utilities provide a comprehensive build system for OpenShift Edge computing CI/CD automation,
including container image building, Ansible execution environments, testing, and reporting.

## Quick Start

### Prerequisites

OS: Mac/Linux supporting the below Applications

#### Applications

| Dependency                                         | Version    | Developed on | Comments                     |
| -------------------------------------------------- | ---------- | ------------ | ---------------------------- |
| [Python3](https://www.python.org/downloads/)       | `>=3.11`   | `3.12.7`     |                              |
| [GNU Make](https://www.gnu.org/software/make/)     | `>=3.82`   | `4.4.1`      | on macOS: `alias make=gmake` |
| [Git](https://git-scm.com/)                        | `>=2.40.0` | `2.51.0`     |                              |
| [Podman](https://podman.io/)                       | `>5.0.0`   | `5.5.2`      |                              |
| [Jinja CLI](https://github.com/cykerway/jinja-cli) |            | `1.2.2`      |                              |

### Setup Instructions

1. **Clone this repository into your existing `eco-ci-cd` project:**

   ```bash
   cd /path/to/your/eco-ci-cd
   git clone https://github.com/openshift-kni/eco-ci-cd-other.git build.util
   ```

    - you may want to have a global `~/.gitignore.global` and add `build.util` to it.

2. **Set up Python virtual environment:**

   ```bash
   python3 -m venv .venv
   source .venv/bin/activate
   pip install -r build.util/requirements.txt
   ```

3. **Run the setup script:**

   ```bash
   ./build.util/setup.sh
   ```

   This script will:
   - Generate `.env` and `vars.mk` files from templates
   - Configure build paths and variables
   - Create backups of existing configuration files

## Build System Overview

This build system provides the ability to run common build tasks running locally.
It has sane defaults inside `makefile.mk`, but these can be overridden in `vars.mk`.
It is currently kept separate from `eco-ci-cd` because it is consumed by prow build automation.

### Core Build Targets

#### Environment Setup

- `bootstrap` - Complete environment setup (Python venv + Ansible collections)
- `venv-ensure` - Ensure Python virtual environment is set up
- `setup-ansible-deps` - Install required Ansible collections

#### Testing & Quality Assurance

- `test` - Run all discovered tests (Ansible + Python)
- `run-python-tests` - Execute Python unit tests with pytest
- `run-pylint` - Run Python code quality checks
- `ansible-lint` - Validate Ansible playbooks and roles
- `test-verify` - Verify test results against expected outputs
- `retest` - Clean environment and run full test suite

#### Ansible Execution

- `run-ansible-e2e-test` - Run end-to-end Ansible tests
- `run-all-e2e-tests` - Execute all E2E test scenarios
- `ee-navigator-run` - Run playbooks using ansible-navigator

#### Container Image Management

- `image-build` - Build container images for the project
- `image-tag` - Tag container images
- `image-push` - Push images to container registry

#### Maintenance

- `clean` - Clean test artifacts and temporary files
- `python-deps-update` - Update Python dependencies
- `python-deps-save` - Save updated dependencies to git

### Configuration

The build system uses several configuration files:

- **`.env`** - Environment variables (generated from template)
- **`vars.mk`** - Make variables (generated from template)
- **`pyproject.toml`** - Python project configuration
- **`requirements.yml`** - Ansible Galaxy requirements

### Key Features

#### Intelligent Test Discovery

The system automatically discovers and runs:

- Ansible playbooks matching `test-*.yml` patterns
- Python tests in role directories (`test_*.py`)
- Role-specific test playbooks (`tests/test.yml`)

#### Multi-Environment Support

- **DCI Integration** - Support for DCI (Distributed CI) workflows
- **Jenkins Integration** - Jenkins pipeline compatibility
- **Container Environments** - Podman/Docker container support
- **Execution Environments** - Ansible EE for consistent execution

#### Advanced Build Features

- **Parallel Execution** - Optimized for concurrent operations
- **Smart Caching** - Efficient dependency and artifact caching
- **Error Recovery** - Robust error handling and recovery mechanisms
- **Debug Support** - Comprehensive debugging and logging options

## Usage Examples

### Basic Development Workflow

```bash
# Set up environment
source .env
make -f build.util/makefile.mk bootstrap

# Run tests
make -f build.util/makefile.mk test

# Build container image
make -f build.util/makefile.mk image-build

# Run specific test component
make -f build.util/makefile.mk run-ansible-e2e-test COMPONENT=dci
```

### Advanced Usage

```bash
# Run with debug output
make -f build.util/makefile.mk test SCRIPT_DEBUG=1

# Clean and rebuild everything
make -f build.util/makefile.mk clean RECREATE=1
make -f build.util/makefile.mk bootstrap
make -f build.util/makefile.mk test

# Build and push execution environment
make -f build.util/makefile.mk ee-build
make -f build.util/makefile.mk ee-push
```

### Environment Variables

Key environment variables that can be customized:

- `PYTHON_VERSION` - Python version to use (default: 3.12)
- `TARGET_DIR` - Target directory for operations (default: playbooks)
- `COMPONENT` - Specific component to test
- `DRY_RUN` - Enable dry-run mode (1 to enable)
- `SCRIPT_DEBUG` - Enable debug output (1 to enable)

## Project Structure

```shell
eco-ci-cd/
├── build.util/          # This repository (build utilities)
│   ├── makefile.mk      # Main build system makefile
│   ├── setup.sh         # Setup script
│   ├── templates/       # Configuration templates
│   └── requirements.txt # Python dependencies
├── playbooks/           # Ansible playbooks and roles
├── inventories/         # Ansible inventories
├── scripts/             # Utility scripts
└── tests/               # Test suites
```

## Contributing

When contributing to the build system:

1. Follow the existing code style and patterns
2. Test changes thoroughly across different environments
3. Update documentation for new features
4. Ensure backward compatibility when possible

## Troubleshooting

### Common Issues

**Virtual Environment Issues:**

```bash
# Reset virtual environment
make -f build.util/makefile.mk clean RECREATE=1
make -f build.util/makefile.mk venv-ensure
```

**Ansible Collection Issues:**

```bash
# Reinstall collections
make -f build.util/makefile.mk setup-ansible-deps
```

**Container Build Issues:**

```bash
# Clean and rebuild
make -f build.util/makefile.mk ee-clean
make -f build.util/makefile.mk ee-build
```

## Related Documentation

- [Reporting Setup Guide](../docs/reporting_setup.md) - Detailed reporting system documentation
- [eco-ci-cd Main Repository](https://github.com/openshift-kni/eco-ci-cd) - Main project repository

## License

This project follows the same license as the main eco-ci-cd project.
