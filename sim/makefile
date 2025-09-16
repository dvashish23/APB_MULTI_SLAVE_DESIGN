//***************************************************************
//
// Author :- Saroj Ashish
// Designation :- Design and Verification Engineer
//
//***************************************************************

#makefile for apb_slave_wrapper design for automation

RTL = ../rtl/mod_n_cntr.v ../rtl/apb_slave.v ../rtl/apb_slave_wrap.v
TB  = ../tb/apb_master_tb.sv


ifeq ($(TOOL),irun)
  #if you have cadence ncsim tool then use irun command
  COMPILE = irun -sv -access +rwc -coverage all -covoverwrite -compile $(RTL) $(TB)
  ELAB    = irun -sv -access +rwc -coverage all -covoverwrite -elaborate $(RTL) $(TB)
  SIM     = irun -sv -access +rwc -coverage all -covoverwrite $(RTL) $(TB)
endif

ifeq ($(TOOL), xrun)
  #if you have cadence xcelium tool then use xrun command
  COMPILE = xrun -sv -access +rwc -coverage all -covoverwrite -compile $(RTL) $(TB)
  ELAB    = xrun -sv -access +rwc -coverage all -covoverwrite -elaborate $(RTL) $(TB)
  SIM     = xrun -sv -access +rwc -coverage all -covoverwrite $(RTL) $(TB)
endif

run:
	$(COMPILE) 
	$(ELAB) 
	$(SIM)

#for cleaning junk file in sim directory
clean:
	rm -rf INCA_libs xcelium.d xrun.* irun.* dump.* cov_work

help:
	@echo "------------------------------------------------------------------------------------------------"
	@echo "------------------------------------------------------------------------------------------------"
	@echo ""
	@echo "make run TOOL=xrun/irun  --> for compile elaborate simulate with tool selection option "
	@echo "make clean               --> for cleaning tools library files and funk files from sim directory "
	@echo ""
	@echo "------------------------------------------------------------------------------------------------"
	@echo "------------------------------------------------------------------------------------------------"

