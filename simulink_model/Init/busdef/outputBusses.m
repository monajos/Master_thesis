function outputBusses() 
% OUTPUTBUSSES initializes a set of bus objects in the MATLAB base workspace 

% Bus object: bu_ISA 
clear elems;
elems(1) = Simulink.BusElement;
elems(1).Name = 'r8rhstat';
elems(1).Dimensions = 1;
elems(1).DimensionsMode = 'Fixed';
elems(1).DataType = 'double';
elems(1).SampleTime = -1;
elems(1).Complexity = 'real';
elems(1).Min = [];
elems(1).Max = [];
elems(1).DocUnits = '';
elems(1).Description = '';

elems(2) = Simulink.BusElement;
elems(2).Name = 'r8Pstat';
elems(2).Dimensions = 1;
elems(2).DimensionsMode = 'Fixed';
elems(2).DataType = 'double';
elems(2).SampleTime = -1;
elems(2).Complexity = 'real';
elems(2).Min = [];
elems(2).Max = [];
elems(2).DocUnits = '';
elems(2).Description = '';

elems(3) = Simulink.BusElement;
elems(3).Name = 'r8Tstat';
elems(3).Dimensions = 1;
elems(3).DimensionsMode = 'Fixed';
elems(3).DataType = 'double';
elems(3).SampleTime = -1;
elems(3).Complexity = 'real';
elems(3).Min = [];
elems(3).Max = [];
elems(3).DocUnits = '';
elems(3).Description = '';

elems(4) = Simulink.BusElement;
elems(4).Name = 'ui4_ISAsegment';
elems(4).Dimensions = 1;
elems(4).DimensionsMode = 'Fixed';
elems(4).DataType = 'uint32';
elems(4).SampleTime = -1;
elems(4).Complexity = 'real';
elems(4).Min = [];
elems(4).Max = [];
elems(4).DocUnits = '';
elems(4).Description = '';

elems(5) = Simulink.BusElement;
elems(5).Name = 'ui4_ISAwidth';
elems(5).Dimensions = 1;
elems(5).DimensionsMode = 'Fixed';
elems(5).DataType = 'double';
elems(5).SampleTime = -1;
elems(5).Complexity = 'real';
elems(5).Min = [];
elems(5).Max = [];
elems(5).DocUnits = '';
elems(5).Description = '';

elems(6) = Simulink.BusElement;
elems(6).Name = 'r8H';
elems(6).Dimensions = 1;
elems(6).DimensionsMode = 'Fixed';
elems(6).DataType = 'double';
elems(6).SampleTime = -1;
elems(6).Complexity = 'real';
elems(6).Min = [];
elems(6).Max = [];
elems(6).DocUnits = '';
elems(6).Description = '';

bu_ISA = Simulink.Bus;
bu_ISA.HeaderFile = '';
bu_ISA.Description = '';
bu_ISA.DataScope = 'Auto';
bu_ISA.Alignment = -1;
bu_ISA.Elements = elems;
clear elems;
assignin('base','bu_ISA', bu_ISA);

% Bus object: bu_XaircraftDot 
clear elems;
elems(1) = Simulink.BusElement;
elems(1).Name = 'bu_XmotionEqDot';
elems(1).Dimensions = 1;
elems(1).DimensionsMode = 'Fixed';
elems(1).DataType = 'bu_XmotionEqDot';
elems(1).SampleTime = -1;
elems(1).Complexity = 'real';
elems(1).Min = [];
elems(1).Max = [];
elems(1).DocUnits = '';
elems(1).Description = '';

bu_XaircraftDot = Simulink.Bus;
bu_XaircraftDot.HeaderFile = '';
bu_XaircraftDot.Description = '';
bu_XaircraftDot.DataScope = 'Auto';
bu_XaircraftDot.Alignment = -1;
bu_XaircraftDot.Elements = elems;
clear elems;
assignin('base','bu_XaircraftDot', bu_XaircraftDot);

% Bus object: bu_XmotionEqDot 
clear elems;
elems(1) = Simulink.BusElement;
elems(1).Name = 'r8x3om_fDot';
elems(1).Dimensions = [3 1];
elems(1).DimensionsMode = 'Fixed';
elems(1).DataType = 'double';
elems(1).SampleTime = -1;
elems(1).Complexity = 'real';
elems(1).Min = [];
elems(1).Max = [];
elems(1).DocUnits = '';
elems(1).Description = '';

elems(2) = Simulink.BusElement;
elems(2).Name = 'r8x3attitudeDot';
elems(2).Dimensions = [3 1];
elems(2).DimensionsMode = 'Fixed';
elems(2).DataType = 'double';
elems(2).SampleTime = -1;
elems(2).Complexity = 'real';
elems(2).Min = [];
elems(2).Max = [];
elems(2).DocUnits = '';
elems(2).Description = '';

elems(3) = Simulink.BusElement;
elems(3).Name = 'r8x3VK_fDot';
elems(3).Dimensions = [3 1];
elems(3).DimensionsMode = 'Fixed';
elems(3).DataType = 'double';
elems(3).SampleTime = -1;
elems(3).Complexity = 'real';
elems(3).Min = [];
elems(3).Max = [];
elems(3).DocUnits = '';
elems(3).Description = '';

elems(4) = Simulink.BusElement;
elems(4).Name = 'r8x3rCG0_gDot';
elems(4).Dimensions = [3 1];
elems(4).DimensionsMode = 'Fixed';
elems(4).DataType = 'double';
elems(4).SampleTime = -1;
elems(4).Complexity = 'real';
elems(4).Min = [];
elems(4).Max = [];
elems(4).DocUnits = '';
elems(4).Description = '';

bu_XmotionEqDot = Simulink.Bus;
bu_XmotionEqDot.HeaderFile = '';
bu_XmotionEqDot.Description = '';
bu_XmotionEqDot.DataScope = 'Auto';
bu_XmotionEqDot.Alignment = -1;
bu_XmotionEqDot.Elements = elems;
clear elems;
assignin('base','bu_XmotionEqDot', bu_XmotionEqDot);

% Bus object: bu_aero 
clear elems;
elems(1) = Simulink.BusElement;
elems(1).Name = 'bu_wingFuse';
elems(1).Dimensions = 1;
elems(1).DimensionsMode = 'Fixed';
elems(1).DataType = 'bu_wingFuse';
elems(1).SampleTime = -1;
elems(1).Complexity = 'real';
elems(1).Min = [];
elems(1).Max = [];
elems(1).DocUnits = '';
elems(1).Description = '';

elems(2) = Simulink.BusElement;
elems(2).Name = 'bu_effFlowARP';
elems(2).Dimensions = 1;
elems(2).DimensionsMode = 'Fixed';
elems(2).DataType = 'bu_effFlowARP';
elems(2).SampleTime = -1;
elems(2).Complexity = 'real';
elems(2).Min = [];
elems(2).Max = [];
elems(2).DocUnits = '';
elems(2).Description = '';

bu_aero = Simulink.Bus;
bu_aero.HeaderFile = '';
bu_aero.Description = '';
bu_aero.DataScope = 'Auto';
bu_aero.Alignment = -1;
bu_aero.Elements = elems;
clear elems;
assignin('base','bu_aero', bu_aero);

% Bus object: bu_aeroCoef 
clear elems;
elems(1) = Simulink.BusElement;
elems(1).Name = 'r8x3forceCoef';
elems(1).Dimensions = [3 1];
elems(1).DimensionsMode = 'Fixed';
elems(1).DataType = 'double';
elems(1).SampleTime = -1;
elems(1).Complexity = 'real';
elems(1).Min = [];
elems(1).Max = [];
elems(1).DocUnits = '';
elems(1).Description = '';

elems(2) = Simulink.BusElement;
elems(2).Name = 'r8x3momentCoef';
elems(2).Dimensions = [3 1];
elems(2).DimensionsMode = 'Fixed';
elems(2).DataType = 'double';
elems(2).SampleTime = -1;
elems(2).Complexity = 'real';
elems(2).Min = [];
elems(2).Max = [];
elems(2).DocUnits = '';
elems(2).Description = '';

bu_aeroCoef = Simulink.Bus;
bu_aeroCoef.HeaderFile = '';
bu_aeroCoef.Description = '';
bu_aeroCoef.DataScope = 'Auto';
bu_aeroCoef.Alignment = -1;
bu_aeroCoef.Elements = elems;
clear elems;
assignin('base','bu_aeroCoef', bu_aeroCoef);

% Bus object: bu_aeroForce 
clear elems;
elems(1) = Simulink.BusElement;
elems(1).Name = 'r8x3RA_f';
elems(1).Dimensions = [3 1];
elems(1).DimensionsMode = 'Fixed';
elems(1).DataType = 'double';
elems(1).SampleTime = -1;
elems(1).Complexity = 'real';
elems(1).Min = [];
elems(1).Max = [];
elems(1).DocUnits = '';
elems(1).Description = '';

elems(2) = Simulink.BusElement;
elems(2).Name = 'r8x3RA_a';
elems(2).Dimensions = [3 1];
elems(2).DimensionsMode = 'Fixed';
elems(2).DataType = 'double';
elems(2).SampleTime = -1;
elems(2).Complexity = 'real';
elems(2).Min = [];
elems(2).Max = [];
elems(2).DocUnits = '';
elems(2).Description = '';

bu_aeroForce = Simulink.Bus;
bu_aeroForce.HeaderFile = '';
bu_aeroForce.Description = '';
bu_aeroForce.DataScope = 'Auto';
bu_aeroForce.Alignment = -1;
bu_aeroForce.Elements = elems;
clear elems;
assignin('base','bu_aeroForce', bu_aeroForce);

% Bus object: bu_aeroMoment 
clear elems;
elems(1) = Simulink.BusElement;
elems(1).Name = 'r8x3MA_f';
elems(1).Dimensions = [3 1];
elems(1).DimensionsMode = 'Fixed';
elems(1).DataType = 'double';
elems(1).SampleTime = -1;
elems(1).Complexity = 'real';
elems(1).Min = [];
elems(1).Max = [];
elems(1).DocUnits = '';
elems(1).Description = '';

elems(2) = Simulink.BusElement;
elems(2).Name = 'r8x3MAARP_f';
elems(2).Dimensions = [3 1];
elems(2).DimensionsMode = 'Fixed';
elems(2).DataType = 'double';
elems(2).SampleTime = -1;
elems(2).Complexity = 'real';
elems(2).Min = [];
elems(2).Max = [];
elems(2).DocUnits = '';
elems(2).Description = '';

bu_aeroMoment = Simulink.Bus;
bu_aeroMoment.HeaderFile = '';
bu_aeroMoment.Description = '';
bu_aeroMoment.DataScope = 'Auto';
bu_aeroMoment.Alignment = -1;
bu_aeroMoment.Elements = elems;
clear elems;
assignin('base','bu_aeroMoment', bu_aeroMoment);

% Bus object: bu_aircraft 
clear elems;
elems(1) = Simulink.BusElement;
elems(1).Name = 'bu_outputVar2';
elems(1).Dimensions = 1;
elems(1).DimensionsMode = 'Fixed';
elems(1).DataType = 'bu_outputVar2';
elems(1).SampleTime = -1;
elems(1).Complexity = 'real';
elems(1).Min = [];
elems(1).Max = [];
elems(1).DocUnits = '';
elems(1).Description = '';

elems(2) = Simulink.BusElement;
elems(2).Name = 'bu_resForceMom';
elems(2).Dimensions = 1;
elems(2).DimensionsMode = 'Fixed';
elems(2).DataType = 'bu_resForceMom';
elems(2).SampleTime = -1;
elems(2).Complexity = 'real';
elems(2).Min = [];
elems(2).Max = [];
elems(2).DocUnits = '';
elems(2).Description = '';

elems(3) = Simulink.BusElement;
elems(3).Name = 'bu_aero';
elems(3).Dimensions = 1;
elems(3).DimensionsMode = 'Fixed';
elems(3).DataType = 'bu_aero';
elems(3).SampleTime = -1;
elems(3).Complexity = 'real';
elems(3).Min = [];
elems(3).Max = [];
elems(3).DocUnits = '';
elems(3).Description = '';

elems(4) = Simulink.BusElement;
elems(4).Name = 'bu_engine';
elems(4).Dimensions = 1;
elems(4).DimensionsMode = 'Fixed';
elems(4).DataType = 'Bus: bu_engine';
elems(4).SampleTime = -1;
elems(4).Complexity = 'real';
elems(4).Min = [];
elems(4).Max = [];
elems(4).DocUnits = '';
elems(4).Description = '';

elems(5) = Simulink.BusElement;
elems(5).Name = 'bu_enviro';
elems(5).Dimensions = 1;
elems(5).DimensionsMode = 'Fixed';
elems(5).DataType = 'bu_enviro';
elems(5).SampleTime = -1;
elems(5).Complexity = 'real';
elems(5).Min = [];
elems(5).Max = [];
elems(5).DocUnits = '';
elems(5).Description = '';

elems(6) = Simulink.BusElement;
elems(6).Name = 'bu_gravity';
elems(6).Dimensions = 1;
elems(6).DimensionsMode = 'Fixed';
elems(6).DataType = 'bu_gravity';
elems(6).SampleTime = -1;
elems(6).Complexity = 'real';
elems(6).Min = [];
elems(6).Max = [];
elems(6).DocUnits = '';
elems(6).Description = '';

elems(7) = Simulink.BusElement;
elems(7).Name = 'bu_outputVar1';
elems(7).Dimensions = 1;
elems(7).DimensionsMode = 'Fixed';
elems(7).DataType = 'bu_outputVar1';
elems(7).SampleTime = -1;
elems(7).Complexity = 'real';
elems(7).Min = [];
elems(7).Max = [];
elems(7).DocUnits = '';
elems(7).Description = '';

elems(8) = Simulink.BusElement;
elems(8).Name = 'r8x3x3I';
elems(8).Dimensions = [3 3];
elems(8).DimensionsMode = 'Fixed';
elems(8).DataType = 'double';
elems(8).SampleTime = -1;
elems(8).Complexity = 'real';
elems(8).Min = [];
elems(8).Max = [];
elems(8).DocUnits = '';
elems(8).Description = '';

bu_aircraft = Simulink.Bus;
bu_aircraft.HeaderFile = '';
bu_aircraft.Description = '';
bu_aircraft.DataScope = 'Auto';
bu_aircraft.Alignment = -1;
bu_aircraft.Elements = elems;
clear elems;
assignin('base','bu_aircraft', bu_aircraft);

% Bus object: bu_aircraftOut 
clear elems;
elems(1) = Simulink.BusElement;
elems(1).Name = 'bu_Xaircraft';
elems(1).Dimensions = 1;
elems(1).DimensionsMode = 'Fixed';
elems(1).DataType = 'bu_Xaircraft';
elems(1).SampleTime = -1;
elems(1).Complexity = 'real';
elems(1).Min = [];
elems(1).Max = [];
elems(1).DocUnits = '';
elems(1).Description = '';

elems(2) = Simulink.BusElement;
elems(2).Name = 'bu_XaircraftDot';
elems(2).Dimensions = 1;
elems(2).DimensionsMode = 'Fixed';
elems(2).DataType = 'bu_XaircraftDot';
elems(2).SampleTime = -1;
elems(2).Complexity = 'real';
elems(2).Min = [];
elems(2).Max = [];
elems(2).DocUnits = '';
elems(2).Description = '';

elems(3) = Simulink.BusElement;
elems(3).Name = 'bu_aircraft';
elems(3).Dimensions = 1;
elems(3).DimensionsMode = 'Fixed';
elems(3).DataType = 'bu_aircraft';
elems(3).SampleTime = -1;
elems(3).Complexity = 'real';
elems(3).Min = [];
elems(3).Max = [];
elems(3).DocUnits = '';
elems(3).Description = '';

bu_aircraftOut = Simulink.Bus;
bu_aircraftOut.HeaderFile = '';
bu_aircraftOut.Description = '';
bu_aircraftOut.DataScope = 'Auto';
bu_aircraftOut.Alignment = -1;
bu_aircraftOut.Elements = elems;
clear elems;
assignin('base','bu_aircraftOut', bu_aircraftOut);

% Bus object: bu_atmos 
clear elems;
elems(1) = Simulink.BusElement;
elems(1).Name = 'bu_wind';
elems(1).Dimensions = 1;
elems(1).DimensionsMode = 'Fixed';
elems(1).DataType = 'bu_wind';
elems(1).SampleTime = -1;
elems(1).Complexity = 'real';
elems(1).Min = [];
elems(1).Max = [];
elems(1).DocUnits = '';
elems(1).Description = '';

elems(2) = Simulink.BusElement;
elems(2).Name = 'bu_ISA';
elems(2).Dimensions = 1;
elems(2).DimensionsMode = 'Fixed';
elems(2).DataType = 'bu_ISA';
elems(2).SampleTime = -1;
elems(2).Complexity = 'real';
elems(2).Min = [];
elems(2).Max = [];
elems(2).DocUnits = '';
elems(2).Description = '';

bu_atmos = Simulink.Bus;
bu_atmos.HeaderFile = '';
bu_atmos.Description = '';
bu_atmos.DataScope = 'Auto';
bu_atmos.Alignment = -1;
bu_atmos.Elements = elems;
clear elems;
assignin('base','bu_atmos', bu_atmos);

% Bus object: bu_effFlowARP 
clear elems;
elems(1) = Simulink.BusElement;
elems(1).Name = 'r8Pdyn';
elems(1).Dimensions = 1;
elems(1).DimensionsMode = 'Fixed';
elems(1).DataType = 'double';
elems(1).SampleTime = -1;
elems(1).Complexity = 'real';
elems(1).Min = [];
elems(1).Max = [];
elems(1).DocUnits = '';
elems(1).Description = '';

elems(2) = Simulink.BusElement;
elems(2).Name = 'r8x3x3T_fa';
elems(2).Dimensions = [3 3];
elems(2).DimensionsMode = 'Fixed';
elems(2).DataType = 'double';
elems(2).SampleTime = -1;
elems(2).Complexity = 'real';
elems(2).Min = [];
elems(2).Max = [];
elems(2).DocUnits = '';
elems(2).Description = '';

elems(3) = Simulink.BusElement;
elems(3).Name = 'bu_flowAng';
elems(3).Dimensions = 1;
elems(3).DimensionsMode = 'Fixed';
elems(3).DataType = 'bu_flowAng';
elems(3).SampleTime = -1;
elems(3).Complexity = 'real';
elems(3).Min = [];
elems(3).Max = [];
elems(3).DocUnits = '';
elems(3).Description = '';

elems(4) = Simulink.BusElement;
elems(4).Name = 'bu_velocityARP';
elems(4).Dimensions = 1;
elems(4).DimensionsMode = 'Fixed';
elems(4).DataType = 'bu_velocityARP';
elems(4).SampleTime = -1;
elems(4).Complexity = 'real';
elems(4).Min = [];
elems(4).Max = [];
elems(4).DocUnits = '';
elems(4).Description = '';

bu_effFlowARP = Simulink.Bus;
bu_effFlowARP.HeaderFile = '';
bu_effFlowARP.Description = '';
bu_effFlowARP.DataScope = 'Auto';
bu_effFlowARP.Alignment = -1;
bu_effFlowARP.Elements = elems;
clear elems;
assignin('base','bu_effFlowARP', bu_effFlowARP);

% Bus object: bu_engine 
clear elems;
elems(1) = Simulink.BusElement;
elems(1).Name = 'r8x3Fen_f';
elems(1).Dimensions = [3 1];
elems(1).DimensionsMode = 'Fixed';
elems(1).DataType = 'double';
elems(1).SampleTime = -1;
elems(1).Complexity = 'real';
elems(1).Min = [];
elems(1).Max = [];
elems(1).DocUnits = '';
elems(1).Description = '';

elems(2) = Simulink.BusElement;
elems(2).Name = 'r8x3Men_f';
elems(2).Dimensions = [3 1];
elems(2).DimensionsMode = 'Fixed';
elems(2).DataType = 'double';
elems(2).SampleTime = -1;
elems(2).Complexity = 'real';
elems(2).Min = [];
elems(2).Max = [];
elems(2).DocUnits = '';
elems(2).Description = '';

bu_engine = Simulink.Bus;
bu_engine.HeaderFile = '';
bu_engine.Description = '';
bu_engine.DataScope = 'Auto';
bu_engine.Alignment = -1;
bu_engine.Elements = elems;
clear elems;
assignin('base','bu_engine', bu_engine);

% Bus object: bu_enviro 
clear elems;
elems(1) = Simulink.BusElement;
elems(1).Name = 'bu_atmos';
elems(1).Dimensions = 1;
elems(1).DimensionsMode = 'Fixed';
elems(1).DataType = 'bu_atmos';
elems(1).SampleTime = -1;
elems(1).Complexity = 'real';
elems(1).Min = [];
elems(1).Max = [];
elems(1).DocUnits = '';
elems(1).Description = '';

bu_enviro = Simulink.Bus;
bu_enviro.HeaderFile = '';
bu_enviro.Description = '';
bu_enviro.DataScope = 'Auto';
bu_enviro.Alignment = -1;
bu_enviro.Elements = elems;
clear elems;
assignin('base','bu_enviro', bu_enviro);

% Bus object: bu_flightPath 
clear elems;
elems(1) = Simulink.BusElement;
elems(1).Name = 'r8VK';
elems(1).Dimensions = 1;
elems(1).DimensionsMode = 'Fixed';
elems(1).DataType = 'double';
elems(1).SampleTime = -1;
elems(1).Complexity = 'real';
elems(1).Min = [];
elems(1).Max = [];
elems(1).DocUnits = '';
elems(1).Description = '';

elems(2) = Simulink.BusElement;
elems(2).Name = 'r8ga';
elems(2).Dimensions = 1;
elems(2).DimensionsMode = 'Fixed';
elems(2).DataType = 'double';
elems(2).SampleTime = -1;
elems(2).Complexity = 'real';
elems(2).Min = [];
elems(2).Max = [];
elems(2).DocUnits = '';
elems(2).Description = '';

elems(3) = Simulink.BusElement;
elems(3).Name = 'r8Ch';
elems(3).Dimensions = 1;
elems(3).DimensionsMode = 'Fixed';
elems(3).DataType = 'double';
elems(3).SampleTime = -1;
elems(3).Complexity = 'real';
elems(3).Min = [];
elems(3).Max = [];
elems(3).DocUnits = '';
elems(3).Description = '';

elems(4) = Simulink.BusElement;
elems(4).Name = 'r8x3VK_g';
elems(4).Dimensions = [3 1];
elems(4).DimensionsMode = 'Fixed';
elems(4).DataType = 'double';
elems(4).SampleTime = -1;
elems(4).Complexity = 'real';
elems(4).Min = [];
elems(4).Max = [];
elems(4).DocUnits = '';
elems(4).Description = '';

bu_flightPath = Simulink.Bus;
bu_flightPath.HeaderFile = '';
bu_flightPath.Description = '';
bu_flightPath.DataScope = 'Auto';
bu_flightPath.Alignment = -1;
bu_flightPath.Elements = elems;
clear elems;
assignin('base','bu_flightPath', bu_flightPath);

% Bus object: bu_flowAng 
clear elems;
elems(1) = Simulink.BusElement;
elems(1).Name = 'r8alARP';
elems(1).Dimensions = 1;
elems(1).DimensionsMode = 'Fixed';
elems(1).DataType = 'double';
elems(1).SampleTime = -1;
elems(1).Complexity = 'real';
elems(1).Min = [];
elems(1).Max = [];
elems(1).DocUnits = '';
elems(1).Description = '';

elems(2) = Simulink.BusElement;
elems(2).Name = 'r8beARP';
elems(2).Dimensions = 1;
elems(2).DimensionsMode = 'Fixed';
elems(2).DataType = 'double';
elems(2).SampleTime = -1;
elems(2).Complexity = 'real';
elems(2).Min = [];
elems(2).Max = [];
elems(2).DocUnits = '';
elems(2).Description = '';

elems(3) = Simulink.BusElement;
elems(3).Name = 'r8VAARP';
elems(3).Dimensions = 1;
elems(3).DimensionsMode = 'Fixed';
elems(3).DataType = 'double';
elems(3).SampleTime = -1;
elems(3).Complexity = 'real';
elems(3).Min = [];
elems(3).Max = [];
elems(3).DocUnits = '';
elems(3).Description = '';

bu_flowAng = Simulink.Bus;
bu_flowAng.HeaderFile = '';
bu_flowAng.Description = '';
bu_flowAng.DataScope = 'Auto';
bu_flowAng.Alignment = -1;
bu_flowAng.Elements = elems;
clear elems;
assignin('base','bu_flowAng', bu_flowAng);

% Bus object: bu_gravity 
clear elems;
elems(1) = Simulink.BusElement;
elems(1).Name = 'r8x3G_f';
elems(1).Dimensions = [3 1];
elems(1).DimensionsMode = 'Fixed';
elems(1).DataType = 'double';
elems(1).SampleTime = -1;
elems(1).Complexity = 'real';
elems(1).Min = [];
elems(1).Max = [];
elems(1).DocUnits = '';
elems(1).Description = '';

elems(2) = Simulink.BusElement;
elems(2).Name = 'r8x3G_g';
elems(2).Dimensions = [3 1];
elems(2).DimensionsMode = 'Fixed';
elems(2).DataType = 'double';
elems(2).SampleTime = -1;
elems(2).Complexity = 'real';
elems(2).Min = [];
elems(2).Max = [];
elems(2).DocUnits = '';
elems(2).Description = '';

bu_gravity = Simulink.Bus;
bu_gravity.HeaderFile = '';
bu_gravity.Description = '';
bu_gravity.DataScope = 'Auto';
bu_gravity.Alignment = -1;
bu_gravity.Elements = elems;
clear elems;
assignin('base','bu_gravity', bu_gravity);

% Bus object: bu_outputVar1 
clear elems;
elems(1) = Simulink.BusElement;
elems(1).Name = 'bu_flightPath';
elems(1).Dimensions = 1;
elems(1).DimensionsMode = 'Fixed';
elems(1).DataType = 'bu_flightPath';
elems(1).SampleTime = -1;
elems(1).Complexity = 'real';
elems(1).Min = [];
elems(1).Max = [];
elems(1).DocUnits = '';
elems(1).Description = '';

elems(2) = Simulink.BusElement;
elems(2).Name = 'bu_trafoMat';
elems(2).Dimensions = 1;
elems(2).DimensionsMode = 'Fixed';
elems(2).DataType = 'bu_trafoMat';
elems(2).SampleTime = -1;
elems(2).Complexity = 'real';
elems(2).Min = [];
elems(2).Max = [];
elems(2).DocUnits = '';
elems(2).Description = '';

elems(3) = Simulink.BusElement;
elems(3).Name = 'bu_posPolar';
elems(3).Dimensions = 1;
elems(3).DimensionsMode = 'Fixed';
elems(3).DataType = 'bu_posPolar';
elems(3).SampleTime = -1;
elems(3).Complexity = 'real';
elems(3).Min = [];
elems(3).Max = [];
elems(3).DocUnits = '';
elems(3).Description = '';

bu_outputVar1 = Simulink.Bus;
bu_outputVar1.HeaderFile = '';
bu_outputVar1.Description = '';
bu_outputVar1.DataScope = 'Auto';
bu_outputVar1.Alignment = -1;
bu_outputVar1.Elements = elems;
clear elems;
assignin('base','bu_outputVar1', bu_outputVar1);

% Bus object: bu_outputVar2 
clear elems;
elems(1) = Simulink.BusElement;
elems(1).Name = 'r8x3nt_f';
elems(1).Dimensions = [3 1];
elems(1).DimensionsMode = 'Fixed';
elems(1).DataType = 'double';
elems(1).SampleTime = -1;
elems(1).Complexity = 'real';
elems(1).Min = [];
elems(1).Max = [];
elems(1).DocUnits = '';
elems(1).Description = '';

elems(2) = Simulink.BusElement;
elems(2).Name = 'r8x3b_f';
elems(2).Dimensions = [3 1];
elems(2).DimensionsMode = 'Fixed';
elems(2).DataType = 'double';
elems(2).SampleTime = -1;
elems(2).Complexity = 'real';
elems(2).Min = [];
elems(2).Max = [];
elems(2).DocUnits = '';
elems(2).Description = '';

bu_outputVar2 = Simulink.Bus;
bu_outputVar2.HeaderFile = '';
bu_outputVar2.Description = '';
bu_outputVar2.DataScope = 'Auto';
bu_outputVar2.Alignment = -1;
bu_outputVar2.Elements = elems;
clear elems;
assignin('base','bu_outputVar2', bu_outputVar2);

% Bus object: bu_posPolar 
clear elems;
elems(1) = Simulink.BusElement;
elems(1).Name = 'r8lat';
elems(1).Dimensions = 1;
elems(1).DimensionsMode = 'Fixed';
elems(1).DataType = 'double';
elems(1).SampleTime = -1;
elems(1).Complexity = 'real';
elems(1).Min = [];
elems(1).Max = [];
elems(1).DocUnits = '';
elems(1).Description = '';

elems(2) = Simulink.BusElement;
elems(2).Name = 'r8lon';
elems(2).Dimensions = 1;
elems(2).DimensionsMode = 'Fixed';
elems(2).DataType = 'double';
elems(2).SampleTime = -1;
elems(2).Complexity = 'real';
elems(2).Min = [];
elems(2).Max = [];
elems(2).DocUnits = '';
elems(2).Description = '';

elems(3) = Simulink.BusElement;
elems(3).Name = 'r8Hellip';
elems(3).Dimensions = 1;
elems(3).DimensionsMode = 'Fixed';
elems(3).DataType = 'double';
elems(3).SampleTime = -1;
elems(3).Complexity = 'real';
elems(3).Min = [];
elems(3).Max = [];
elems(3).DocUnits = '';
elems(3).Description = '';

bu_posPolar = Simulink.Bus;
bu_posPolar.HeaderFile = '';
bu_posPolar.Description = '';
bu_posPolar.DataScope = 'Auto';
bu_posPolar.Alignment = -1;
bu_posPolar.Elements = elems;
clear elems;
assignin('base','bu_posPolar', bu_posPolar);

% Bus object: bu_resForceMom 
clear elems;
elems(1) = Simulink.BusElement;
elems(1).Name = 'r8x3R_f';
elems(1).Dimensions = [3 1];
elems(1).DimensionsMode = 'Fixed';
elems(1).DataType = 'double';
elems(1).SampleTime = -1;
elems(1).Complexity = 'real';
elems(1).Min = [];
elems(1).Max = [];
elems(1).DocUnits = '';
elems(1).Description = '';

elems(2) = Simulink.BusElement;
elems(2).Name = 'r8x3M_f';
elems(2).Dimensions = [3 1];
elems(2).DimensionsMode = 'Fixed';
elems(2).DataType = 'double';
elems(2).SampleTime = -1;
elems(2).Complexity = 'real';
elems(2).Min = [];
elems(2).Max = [];
elems(2).DocUnits = '';
elems(2).Description = '';

bu_resForceMom = Simulink.Bus;
bu_resForceMom.HeaderFile = '';
bu_resForceMom.Description = '';
bu_resForceMom.DataScope = 'Auto';
bu_resForceMom.Alignment = -1;
bu_resForceMom.Elements = elems;
clear elems;
assignin('base','bu_resForceMom', bu_resForceMom);

% Bus object: bu_trafoMat 
clear elems;
elems(1) = Simulink.BusElement;
elems(1).Name = 'r8x3x3T_gf';
elems(1).Dimensions = [3 3];
elems(1).DimensionsMode = 'Fixed';
elems(1).DataType = 'double';
elems(1).SampleTime = -1;
elems(1).Complexity = 'real';
elems(1).Min = [];
elems(1).Max = [];
elems(1).DocUnits = '';
elems(1).Description = '';

elems(2) = Simulink.BusElement;
elems(2).Name = 'r8x3x3T_fg';
elems(2).Dimensions = [3 3];
elems(2).DimensionsMode = 'Fixed';
elems(2).DataType = 'double';
elems(2).SampleTime = -1;
elems(2).Complexity = 'real';
elems(2).Min = [];
elems(2).Max = [];
elems(2).DocUnits = '';
elems(2).Description = '';

bu_trafoMat = Simulink.Bus;
bu_trafoMat.HeaderFile = '';
bu_trafoMat.Description = '';
bu_trafoMat.DataScope = 'Auto';
bu_trafoMat.Alignment = -1;
bu_trafoMat.Elements = elems;
clear elems;
assignin('base','bu_trafoMat', bu_trafoMat);

% Bus object: bu_velocityARP 
clear elems;
elems(1) = Simulink.BusElement;
elems(1).Name = 'r8x3VAARP_f';
elems(1).Dimensions = [3 1];
elems(1).DimensionsMode = 'Fixed';
elems(1).DataType = 'double';
elems(1).SampleTime = -1;
elems(1).Complexity = 'real';
elems(1).Min = [];
elems(1).Max = [];
elems(1).DocUnits = '';
elems(1).Description = '';

elems(2) = Simulink.BusElement;
elems(2).Name = 'r8x3VKARP_f';
elems(2).Dimensions = [3 1];
elems(2).DimensionsMode = 'Fixed';
elems(2).DataType = 'double';
elems(2).SampleTime = -1;
elems(2).Complexity = 'real';
elems(2).Min = [];
elems(2).Max = [];
elems(2).DocUnits = '';
elems(2).Description = '';

bu_velocityARP = Simulink.Bus;
bu_velocityARP.HeaderFile = '';
bu_velocityARP.Description = '';
bu_velocityARP.DataScope = 'Auto';
bu_velocityARP.Alignment = -1;
bu_velocityARP.Elements = elems;
clear elems;
assignin('base','bu_velocityARP', bu_velocityARP);

% Bus object: bu_wind 
clear elems;
elems(1) = Simulink.BusElement;
elems(1).Name = 'r8x3VW_f';
elems(1).Dimensions = [3 1];
elems(1).DimensionsMode = 'Fixed';
elems(1).DataType = 'double';
elems(1).SampleTime = -1;
elems(1).Complexity = 'real';
elems(1).Min = [];
elems(1).Max = [];
elems(1).DocUnits = '';
elems(1).Description = '';

elems(2) = Simulink.BusElement;
elems(2).Name = 'r8x3VW_g';
elems(2).Dimensions = [3 1];
elems(2).DimensionsMode = 'Fixed';
elems(2).DataType = 'double';
elems(2).SampleTime = -1;
elems(2).Complexity = 'real';
elems(2).Min = [];
elems(2).Max = [];
elems(2).DocUnits = '';
elems(2).Description = '';

bu_wind = Simulink.Bus;
bu_wind.HeaderFile = '';
bu_wind.Description = '';
bu_wind.DataScope = 'Auto';
bu_wind.Alignment = -1;
bu_wind.Elements = elems;
clear elems;
assignin('base','bu_wind', bu_wind);

% Bus object: bu_wingFuse 
clear elems;
elems(1) = Simulink.BusElement;
elems(1).Name = 'bu_aeroMoment';
elems(1).Dimensions = 1;
elems(1).DimensionsMode = 'Fixed';
elems(1).DataType = 'bu_aeroMoment';
elems(1).SampleTime = -1;
elems(1).Complexity = 'real';
elems(1).Min = [];
elems(1).Max = [];
elems(1).DocUnits = '';
elems(1).Description = '';

elems(2) = Simulink.BusElement;
elems(2).Name = 'bu_aeroForce';
elems(2).Dimensions = 1;
elems(2).DimensionsMode = 'Fixed';
elems(2).DataType = 'bu_aeroForce';
elems(2).SampleTime = -1;
elems(2).Complexity = 'real';
elems(2).Min = [];
elems(2).Max = [];
elems(2).DocUnits = '';
elems(2).Description = '';

elems(3) = Simulink.BusElement;
elems(3).Name = 'bu_aeroCoef';
elems(3).Dimensions = 1;
elems(3).DimensionsMode = 'Fixed';
elems(3).DataType = 'bu_aeroCoef';
elems(3).SampleTime = -1;
elems(3).Complexity = 'real';
elems(3).Min = [];
elems(3).Max = [];
elems(3).DocUnits = '';
elems(3).Description = '';

elems(4) = Simulink.BusElement;
elems(4).Name = 'r8x10aeroVar';
elems(4).Dimensions = [10 1];
elems(4).DimensionsMode = 'Fixed';
elems(4).DataType = 'double';
elems(4).SampleTime = -1;
elems(4).Complexity = 'real';
elems(4).Min = [];
elems(4).Max = [];
elems(4).DocUnits = '';
elems(4).Description = '';

bu_wingFuse = Simulink.Bus;
bu_wingFuse.HeaderFile = '';
bu_wingFuse.Description = '';
bu_wingFuse.DataScope = 'Auto';
bu_wingFuse.Alignment = -1;
bu_wingFuse.Elements = elems;
clear elems;
assignin('base','bu_wingFuse', bu_wingFuse);

