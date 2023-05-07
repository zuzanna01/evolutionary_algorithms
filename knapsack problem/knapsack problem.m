format long;
clc;
clear;
close("all");

numerAlbumu=310233; 
rng(numerAlbumu);
N=32; % liczba przedmiotów
items(:,1)=round(0.1+0.9*rand(N,1),1); % wagi w przedmiotów
items(:,2)=round(1+99*rand(N,1)); % wartości p przedmiotów

maxWeight = 0.3 * sum(items(:,1)); % maksymalna waga plecaka
penalty = 1 + max(items(:,2)./items(:,1)); % współczynnik kary

options = optimoptions('ga',... 
            'PopulationType', 'bitstring',...
            'PlotFcn', @out,...
            'MaxGenerations', 100,...
            'MaxStallGenerations', 100,...
            'PopulationSize', 2000,...
            'EliteCount', 1,...
            'SelectionFcn', {@selectiontournament},...
            'MigrationFraction', 0.0,...
            'CrossoverFraction', 0.8,... 
            'CrossoverFcn', 'crossoversinglepoint');

rng('shuffle'); % ustawia generowanie liczb pseudolosowych na podstawie aktualnego czasu

[x, fVal] = ga(@(model)fun(model, penalty, maxWeight, items),N,[],[],[],[],[],[],[],[], options);
totalWeight = sum(x*items(:,1));
totalValue = -fVal;
%% Wyświetlanie wyników

fprintf("Wektor wynikowy: " + num2str(x) + "\n");
fprintf("Waga sumaryczna: " + totalWeight + "\n");
fprintf("Wartość sumaryczna: " + totalValue + "\n");

%% Funkcje

function value = fun(temp_x, penalty, maxWeight, items)
    if temp_x * items(:,1) > maxWeight % jeśli wybrane przedmioty przekraczają dopuszczalną wagę
        value = (-1) * temp_x * items(:,2) + penalty*(temp_x * items(:,1) - maxWeight); 
    else
        value = (-1) * temp_x * items(:,2);
    end
end

function state = out(~, state, flag)

    switch flag
        case 'init'
            figure(1)
            title("Wykres wartości funkcji celu w funkcji numeru pokolenia")
            ylabel("Wartość funkcji celu")
            xlabel("Pokolenie")
            hold on
            plot(state.Generation, min(state.Score), 'b.', 'MarkerSize', 10)
            plot(state.Generation, mean(state.Score), 'g.', 'MarkerSize', 10)
            plot(state.Generation, max(state.Score), 'r.', 'MarkerSize', 10)
            legend('min','średnia', 'max','AutoUpdate','off')
            
            figure(2)
            title("Wariancja funkcji celu w funkcji numeru pokolenia")
            ylabel("Wartość funkcji celu")
            xlabel("Pokolenie")
            hold on
            plot(state.Generation, var(state.Score), 'm.', 'MarkerSize', 10)
            legend('wariancja', 'AutoUpdate','off')

        case 'iter'
            figure(1)

            plot(state.Generation, min(state.Score), 'b.', 'MarkerSize', 10)
            plot(state.Generation, max(state.Score), 'r.', 'MarkerSize', 10)
            plot(state.Generation, mean(state.Score), 'g.', 'MarkerSize', 10)
            figure(2)
            plot(state.Generation, var(state.Score), 'm.', 'MarkerSize', 10)
    end
end
