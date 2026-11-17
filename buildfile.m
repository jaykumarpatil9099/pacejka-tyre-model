function plan = buildfile
%BUILDFILE  MATLAB build plan (R2023b+).
%   buildtool            -> static code analysis + unit tests
%   buildtool figures    -> regenerate the README figures
import matlab.buildtool.tasks.CodeIssuesTask
import matlab.buildtool.tasks.TestTask

plan = buildplan(localfunctions);

plan("check") = CodeIssuesTask(["src", "figures", "tests"]);
plan("test")  = TestTask("tests", SourceFiles = "src");

plan.DefaultTasks = ["check", "test"];
end

function figuresTask(~)
% Regenerate the README figures
here = pwd;
cleanup = onCleanup(@() cd(here));
cd(fullfile(fileparts(mfilename("fullpath")), "figures"));
scripts = ["plot_lateral_curves", "plot_longitudinal_curves", ...
           "plot_axle_comparison", "plot_friction_envelope"];
for s = scripts
    run(s);
    close all;
end
end
