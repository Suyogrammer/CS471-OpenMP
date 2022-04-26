finput = fopen('out.txt', 'r');
sizeData = [2 Inf];
data = fscanf(finput, '%f %f', sizeData);
fclose(finput);

effectiveh = data(1,:);
error = data(2,:);

loglog(effectiveh, error, 'r', effectiveh, effectiveh.^2, '--k');
grid on;
legend({'max error', 'h^2'});
xlabel('effective h');
ylabel('max error');


