clear variables; clc; close all;

%%
snapshot_file='10snapshots_03_06_2019.mat';
snapshot_file='ad10';
fails=cell(2,1);
for i=1:10
    failed=pod_test_anucen(snapshot_file,i);
    if failed(1)>0, fails{1}=[fails{1} failed(1)];end
    if failed(2)>0, fails{2}=[fails{2} failed(2)];end
end
fprintf('Training points that did not pass the test for Monolithic ROM:\n');
if length(fails{1})>0
    fprintf('%d ',fails{1});
    fprintf('\n');
else
    fprintf('None\n');
end
fprintf('Training points that did not pass the test for Group-wise ROM:\n');
if length(fails{2})>0
    fprintf('%d ',fails{2});
    fprintf('\n');
else
    fprintf('None\n');
end

pause

%%
snapshot_file='20snapshots_03_06_2019.mat';
snapshot_file='ad20';
fails=cell(2,1);
for i=1:20
    failed=pod_test_anucen(snapshot_file,i);
    if failed(1)>0, fails{1}=[fails{1} failed(1)];end
    if failed(2)>0, fails{2}=[fails{2} failed(2)];end
end
fprintf('Training points that did not pass the test for Monolithic ROM:\n');
if length(fails{1})>0
    fprintf('%d ',fails{1});
    fprintf('\n');
else
    fprintf('None\n');
end
fprintf('Training points that did not pass the test for Group-wise ROM:\n');
if length(fails{2})>0
    fprintf('%d ',fails{2});
    fprintf('\n');
else
    fprintf('None\n');
end

pause

%%
snapshot_file='50snapshots_03_06_2019.mat';
snapshot_file='ad50';
fails=cell(2,1);
for i=1:50
    failed=pod_test_anucen(snapshot_file,i);
    if failed(1)>0, fails{1}=[fails{1} failed(1)];end
    if failed(2)>0, fails{2}=[fails{2} failed(2)];end
end
fprintf('Training points that did not pass the test for Monolithic ROM:\n');
if length(fails{1})>0
    fprintf('%d ',fails{1});
    fprintf('\n');
else
    fprintf('None\n');
end
fprintf('Training points that did not pass the test for Group-wise ROM:\n');
if length(fails{2})>0
    fprintf('%d ',fails{2});
    fprintf('\n');
else
    fprintf('None\n');
end

pause

%%
snapshot_file='100snapshots_03_06_2019.mat';
snapshot_file='ad100';
fails=cell(2,1);
for i=1:100
    failed=pod_test_anucen(snapshot_file,i);
    if failed(1)>0, fails{1}=[fails{1} failed(1)];end
    if failed(2)>0, fails{2}=[fails{2} failed(2)];end
end
fprintf('Training points that did not pass the test for Monolithic ROM:\n');
if length(fails{1})>0
    fprintf('%d ',fails{1});
    fprintf('\n');
else
    fprintf('None\n');
end
fprintf('Training points that did not pass the test for Group-wise ROM:\n');
if length(fails{2})>0
    fprintf('%d ',fails{2});
    fprintf('\n');
else
    fprintf('None\n');
end

