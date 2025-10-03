clc;
clear all;

% for ideal case
w = Solution('liquidvapor.xml', 'water');

% Initialize arrays to store results
efficiency_values = [];
net_work_output = [];
Pb_values = [];
Pc_values = [];

% Vary Pb and Pc within the specified ranges
for Pb = linspace(12e6, 15e6, 5)
    for Pc = linspace(10e2, 5e3, 5)
        P1 = Pc;
        P5 = Pb; %Varying
        P4 = Pb;
        P10 = P1;
        P6 = 10e+6; %Pa %Fix
        P7 = P6;
        T5 = 500+273.15; %K
        T7 = 500+273.15; %K
        T9 = T7;
        P2 = 12e+6; %Pa %Fix
        P3 = P2;
        P8 = P2;
        P9 = P8;

        % state 1
        x1 = 0;
        setState_Psat(w, [P1, x1]);
        v1 = 1/density(w); % specific volume (in m^3/kg)
        h1 = enthalpy_mass(w); % enthalpy (in J/kg)

        % State 2
        w1 = v1*(P2-P1);
        h2 = h1 + w1;

        % State 3
        x3 = 0;
        setState_Psat(w, [P3, x3]);
        v3 = 1/density(w); % specific volume (in m^3/kg)
        h3 = enthalpy_mass(w); % enthalpy (in J/kg)

        % State 4
        w2 = v3*(P4-P3);
        h4 = h3 + w2;

        % State 5
        set(w, 'P', P5, 'T', T5);
        h5 = enthalpy_mass(w);
        s5 = entropy_mass(w);

        % State 6
        setState_SP(w, [s5, P6]);
        v6 = 1/density(w); % specific volume (in m^3/kg)
        h6 = enthalpy_mass(w); % enthalpy (in J/kg)

        % State 7
        set(w, 'P', P7, 'T', T7);
        h7 = enthalpy_mass(w);
        s7 = entropy_mass(w);

        % State 8
        s8 = s7;
        setState_SP(w, [s8, P8]);
        h8 = enthalpy_mass(w);
        q8 = vaporFraction(w);

        % State 9
        set(w, 'P', P9, 'T', T9);
        h9 = enthalpy_mass(w);
        s9 = entropy_mass(w);

        % State 10
        s10 = s9;
        setState_SP(w, [s10, P10]);
        h10 = enthalpy_mass(w);
        q10 = vaporFraction(w);

        y = (h3-h2)/(h8-h2);
        eta1 = ((h10-h1)*(1-y))/(h5-h4+h7-h6+(1-y)*(h9-h8));

        % Net work output
        work_output = h5-h6+h7-h8+(1-y)*(h9-h10);

        % Store results
        efficiency_values = [efficiency_values, eta1];
        net_work_output = [net_work_output, work_output];
        Pb_values = [Pb_values, Pb];
        Pc_values = [Pc_values, Pc];
    end
end

% Plot results
figure;
subplot(2,1,1);
scatter3(Pb_values, Pc_values, efficiency_values, 'filled');
title('Effect of Boiler and Condenser Pressures on Efficiency');
xlabel('Boiler Pressure (Pa)');
ylabel('Condenser Pressure (Pa)');
zlabel('Efficiency');

subplot(2,1,2);
scatter3(Pb_values, Pc_values, net_work_output, 'filled');
title('Effect of Boiler and Condenser Pressures on Net Work Output');
xlabel('Boiler Pressure (Pa)');
ylabel('Condenser Pressure (Pa)');
zlabel('Net Work Output');
