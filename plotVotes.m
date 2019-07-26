function [] = plotVotes(currentVotes, addVotes, names, quota)
    winners=horzcat([], find(currentVotes>=floor(quota)));
    bottom=currentVotes-addVotes; %old votes (bottom of bar)
    combined=[bottom; addVotes]';
    b=bar(combined, 'stacked','FaceColor','flat'); hold on; %plot bar graph
    set(gcf, 'Position', get(0, 'Screensize')); %make plot full screen
    xlim=get(gca,'xlim'); plot(xlim,[floor(quota) floor(quota)], 'k'); hold off %plot quota line
    h=gcf; h.CurrentAxes.XTickLabel=names; %put candidate names at bottom
    title('Current Votes'); xlabel('Candidates'); ylabel('Votes') %labels
    for g=1:length(winners) %turn winners green
        b(1).CData(winners(g),:) = [0, 0.5, 0];
        b(2).CData(winners(g),:) = [0.4660, 0.6740, 0.1880];
    end
    y=find(currentVotes>0);
    for z=1:length(y) %display values above bars for non-zero elements
        v=y(z);
        text(v, currentVotes(v), num2str(currentVotes(v)),'vert','bottom','horiz','center');
    end
    pause(2) %time between each plot change