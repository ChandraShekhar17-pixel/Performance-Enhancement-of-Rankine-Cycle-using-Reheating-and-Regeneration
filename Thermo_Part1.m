clc;
clear all;

w = Solution('liquidvapor.xml', 'water'); 
% All pressure are in Pa
P1 = 10e+3;
P5 = 15e+6;
P8 = 10e+3;
P4 = 15e+6;
P10 = 10e+6;
T5 = 500+273.15; % K
T7 = 500+273.15; % K
T9 = T7;
P2 = 12e+6; % K

while P2 > P10
    P3 = P2;
    P8 = P2;
    P9 = P8;
    x1 = 0;
    setState_Psat(w, [P1, x1]);
    v1 = 1/density(w);       % specific volume (in m^3/kg)
    h1 = enthalpy_mass(w);   % enthalpy (in J/kg)

    % State 2
    w_pin1 = v1 * (P2 - P1);
    h2 = h1 + w_pin1;

    % State 3
    x3 = 0;
    setState_Psat(w, [P3, x3]);
    v3 = 1/density(w);       % specific volume (in m^3/kg)
    h3 = enthalpy_mass(w);   % enthalpy (in J/kg)

    % State 4
    w_pin2 = v3 * (P4 - P3);
    h4 = h3 + w_pin2;

    % State 5
    set(w, 'P', P5, 'T', T5);
    h5 = enthalpy_mass(w);
    s5 = entropy_mass(w);

    % State 6
    setState_SP(w, [s5, P6]);
    v6 = 1/density(w);       % specific volume (in m^3/kg)
    h6 = enthalpy_mass(w);   % enthalpy (in J/kg)

    % State 7
    set(w, 'P', P7, 'T', T7);
    h7 = enthalpy_mass(w);
    s7 = entropy_mass(w);

    % State 8
    s8 = s7;
    setState_SP(w, [s8, P8]);
    h8 = enthalpy_mass(w);
    % q8 = vaporFraction(w);

    % State 9
    set(w, 'P', P9, 'T', T9);
    h9 = enthalpy_mass(w);
    s9 = entropy_mass(w);

    % State 10
    s10 = s9;
    setState_SP(w, [s10, P10]);
    h10 = enthalpy_mass(w);
    q10 = vaporFraction(w);

    y = (h3 - h2) / (h8 - h2);
    eta = 1 - ((h10 - h1) * (1 - y)) / ( (h5 - h4 + h7 - h6 * (1 - y)) * (h9 - h8) );

    disp(["P2/P3/P6", P8, "Quality", q10, "ETA", eta]);

    P2 = P2 / 2;
end
