% parse HCP relational text files into MATLAB data structure for modeling

clear;

f = dir('rawRelation/*.txt');

% col CD: block type: "Relational" or "Control"
% col BX: instruction: "TEX" or "SHA" (for relational), "Shape" or "Texture" (for
% control) -- presumably not displayed for relational but indicates on
% which dimension top target pair are matched
% for relational
% col DA: response: 2 = Yes or 3 = No
% col DB: correct response: 2 or 3
% col CY: accuracy: 0 or 1
% col CZ: response time: real number in ms
% for control they are in EH, EI, EF, and EG

totalTrial = 0;
for idx = 1:numel(f)
    warning off
T = readtable(sprintf('rawRelation/%s', f(idx).name));
warning on

    tmp = split(f(idx).name, '.');
            d.participantID(idx) =  str2num(tmp{1});
            
    match = find(contains(T{:, ExcelColNo('CD')}, {'Relational', 'Control'}));

    for i = 1:length(match)
        totalTrial = totalTrial + 1;
        d.participant(totalTrial) = idx;
        d.trial(totalTrial) = i;
        tmp = T{match(i), ExcelColNo('CD')};
        switch tmp{1}
            case 'Control', d.condition(totalTrial) = 1;
            case 'Relational', d.condition(totalTrial) = 2;
        end
        
        % control
        if d.condition(totalTrial) == 1
            tmp = T{match(i), ExcelColNo('EH')};
        switch tmp
            case 3, d.response(totalTrial) = 0;
            case 2, d.response(totalTrial) = 1;
        end
        tmp = T{match(i), ExcelColNo('BX')};
        switch tmp{1}
            case 'Shape', d.dimension(totalTrial) = 1;
            case 'Texture', d.dimension(totalTrial) = 2;
        end
        tmp = T{match(i), ExcelColNo('EI')};
        switch tmp
            case 3, d.truth(totalTrial) = 0;
            case 2, d.truth(totalTrial) = 1;
        end
        d.accuracy(totalTrial) = T{match(i), ExcelColNo('EF')};
         d.rt(totalTrial) = T{match(i), ExcelColNo('EG')};
            
         % relation
        elseif d.condition(totalTrial) == 2
        tmp = T{match(i), ExcelColNo('DA')};
        switch tmp
            case 3, d.response(totalTrial) = 0;
            case 2, d.response(totalTrial) = 1;
        end
        tmp = T{match(i), ExcelColNo('BX')};
        switch tmp{1}
            case 'SHA', d.dimension(totalTrial) = 1;
            case 'TEX', d.dimension(totalTrial) = 2;
        end
        tmp = T{match(i), ExcelColNo('DB')};
        switch tmp
            case 3, d.truth(totalTrial) = 0;
            case 2, d.truth(totalTrial) = 1;
        end
        d.accuracy(totalTrial) = T{match(i), ExcelColNo('CY')};
         d.rt(totalTrial) = T{match(i), ExcelColNo('CZ')};
        end
   end
end

d.info = {'condition 1 = control, 2 = relation', 'dimension 1 = shape, 2 = texture'};

save('relationTaskHCP', 'd');
