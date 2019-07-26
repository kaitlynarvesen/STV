function winners = STV(file, seats)

    %import data, initialize stuff
    [data, names] = xlsread(file);
    [votes, candidates]=size(data);
    currentVotes=zeros(1, candidates); winners=[]; addVotes=zeros(1, candidates);
    s=true; t=true;
    if(isempty(names))
        names=num2cell(1:candidates);
    end

    %compute threshhold required to win
    quota=votes/(seats+1)+1;

    %allocate votes according to 1st picks
    for i=1:candidates
        currentVotes(i)=sum(data(:, i) == 1);
    end
    disp("votes:")
    disp(currentVotes) %display original votes (1st picks)
    figure(1); plotVotes(currentVotes, addVotes, names, quota);

    while  t==true
        while s==true
            addVotes=zeros(1, candidates); %reset each round
            %A- everyone over the threshhold marked as winner
            newWinners=horzcat([], find(currentVotes>quota));
            if(isempty(newWinners)) %if no new winners, skip to elimination
                break
            end
            winners=union(winners, newWinners); %add new winners to old winners

            if(length(winners)>=seats) %if all seats filled, election is over
                disp("winners:")
                for w=1:length(winners)
                    disp(names(winners(w)))
                end
                return
            end

            %B- excess votes from winners are transferred based on next ranking preference
            for i=1:length(newWinners) %distribute excess votes for each new winner
                j=newWinners(i);
                ratio=(currentVotes(j)-quota)/currentVotes(j);
                data=data-(data(:, j) == 1);
                dataTemp=data(data(:, j) == 0, :);
                for k=1:candidates %calculate how many redistributed votes each candidate gets
                    if(k==j)
                        currentVotes(k)=floor(quota);
                        continue
                    end
                    addVotes(k)=floor(ratio*sum(dataTemp(:, k) == 1));
                end
                currentVotes=currentVotes+addVotes; %add new votes to old votes
                disp(currentVotes) %display new row of all current votes after redistribution
                plotVotes(currentVotes, addVotes, names, quota)
            end
        end
        %C- repeat A, B until nobody new is elected

        %D- when no new winner found, eliminate lowest person and redistribute all of their votes
        m=find(currentVotes == min(currentVotes(currentVotes>0))); %find minimum votes
        j=m(1); %if there are more than one tied for lowest, it will only deal with the first one
        %redistribute votes, same as above
        data=data-(data(:, j) == 1);
        dataTemp=data(data(:, j) == 0, :);
        [x, ~]=size(dataTemp);
        ratio=currentVotes(j)/x;
        for k=1:candidates
            if(k==j)
                currentVotes(k)=0;
                continue
            end
            addVotes(k)=floor(ratio*sum(dataTemp(:, k) == 1));
        end
        currentVotes=currentVotes+addVotes;
        disp(currentVotes) %display new vote totals after redistribution
        plotVotes(currentVotes, addVotes, names, quota)
        for r=1:votes %reset preferences to eliminate loser's future votes
            if(data(r, j)>0)
            for c=1:candidates
                if(data(r, c)>data(r, j))
                    data(r, c)=data(r, c)-1;
                end
            end
            data(r, j)=data(r, j)-1;
            end
        end
        currentVotes(:, j)=0; %delete data for loser
        addVotes(:, j)=0;
        data(:, j)=0;
    end
    %repeat A-E until finished (all seats filled)

