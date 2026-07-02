##==============================================================================
## [Filename]       project.mk
## [Project]        -
## [Author]         Ciro Bermudez - cirofabian.bermudez@gmail.com
## [Language]       GNU Makefile
## [Created]        -
## [Modified]       -
## [Description]    Directed project
## [Notes]          -
## [Status]         stable
## [Revisions]      -
##==============================================================================

# ================================ DIRECTORIES =================================
# Project paths and directory hierarchy

GIT_DIR       := $(shell git rev-parse --show-toplevel)
TB_DIR        ?= $(GIT_DIR)/verification/directed
COMMON_MK_DIR := $(GIT_DIR)/verification/common/mk

# =============================== CONFIGURATION ================================
# Project-specific defaults

# -------------------------------- COMPILE-TIME --------------------------------

# TIMESCALE               ?= 1ps/100fs
# ENABLE_UVM              ?= false
# UVM_VERSION             ?= 1.2
ENABLE_DEBUG_DB         ?= true
DEFINES                 ?= +define+ERROR1_VERSION
# COMPILE_ARGS            ?=
SIMV_NAME               ?= simv2
ENABLE_CODE_COV_COMPILE ?= true
CODE_COV_TYPES_COMPILE  ?= line+cond+tgl
ENABLE_SVA_COMPILE      ?= true
UVCS_FILELIST           ?=
DPI_FILE                ?= $(COMMON_DPI_DIR)/lib/libdpi.so

# ---------------------------------- RUN-TIME ----------------------------------

# TEST                      ?= top_test
# VERBOSITY                 ?= UVM_MEDIUM
# SEED_MODE                 ?= fixed
# SEED                      ?= 5081996
ENABLE_UVM_RECORDING      ?= false
ENABLE_CODE_COV_RUN       ?= true
CODE_COV_TYPES_RUN        ?= line+cond+tgl
ENABLE_SVA_RUN            ?= true
DUMP_MODE                 ?= default
JOB_NAME                  ?= miguel_test
RUN_ARGS                  ?= +iterations=100

# ================================== INCLUDES ==================================

# Main framework
include $(COMMON_MK_DIR)/common.mk

# DPI
-include $(COMMON_MK_DIR)/dpi.mk

# Coverage
-include $(COMMON_MK_DIR)/cov.mk

# Regression Manager
# -include $(MK_DIR)/regression.mk

# ================================= HELP MENU ==================================

.PHONY: help
help: ## COMMON: Displays help message
	@printf "%s\n" "================================================================================"
	@printf "%s\n" "                                    PROJECT.MK                                  "
	@printf "%s\n" "================================================================================"
	@printf "%s\n" "Usage: make <target> [variables]"
	@printf "%s\n" "------------------------------------ TARGETS -----------------------------------"
	@grep -h -E '^help-[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	awk 'BEGIN {FS = ":.*?## "}; {printf "- make $(C_CYN)%-15s$(C_RST) %s\n", $$1, $$2}'
	@printf "%s\n" "================================================================================"
