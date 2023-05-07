function stop = out(x, ~, state)
stop = false;
switch state
    case 'init'
        fun = @(x,y)(2.5-x)^2 + 100*(y-(x-1.5)^2)^2;
        fcontour(fun,[-1 4],LevelStep=30);
        colorbar;
        hold on;
        plot(x(1),x(2), 'ro', 'MarkerSize', 12);
        text(x(1)+0.15,x(2), "START");
    case 'iter'
        plot(x(1),x(2), '.', 'MarkerSize', 10);
        quiver(temp(1),temp(2),x(1),x(2));
    case 'done'
        plot(x(1),x(2), 'ro', 'MarkerSize', 12);
        text(x(1)+0.15,x(2), "FINISH");
end
end