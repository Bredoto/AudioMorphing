function [snake_pnts,global_e] = grad_snake(pnts,alpha,beta,max_delta,resol,gx,gy)

  n = size(pnts,1);
  [row,col] = size(gx);
  target = reshape(sqrt(gx.^2+gy.^2),row*col,1);
  scan = -max_delta:resol:max_delta;
  num_scan = size(scan,2);
  num_states = num_scan^2;

  fprintf('n = %d; num_states = %d; ',n,num_states);

  delta_x = ones(num_scan,1)*scan;
  delta_y = delta_x';
  delta_x = reshape(delta_x,1,num_states);
  delta_y = reshape(delta_y,1,num_states);

  states_x = pnts(:,1)*ones(1,num_states) + ones(n,1)*delta_x;
  states_y = pnts(:,2)*ones(1,num_states) + ones(n,1)*delta_y;
  states_i = (states_x-1)*row + states_y;

  Smat = zeros(n,num_states^2);
  Imat = zeros(n,num_states^2);

  % forward pass

  for v2 = 1:num_states,
    Smat(1,(v2-1)*num_states+1:v2*num_states) = ...
      -target(states_i(1,:))';
  end;

  for k = 2:n-1,
    fprintf('.');  % debug
    for v2 = 1:num_states, for v1 = 1:num_states,
      v0_domain = 1:num_states;
      [y,i] = min( Smat(k-1,(v1-1)*num_states+v0_domain) ...
              + alpha(k)*( (states_x(k,v1)-states_x(k-1,v0_domain)).^2 ...
                      + (states_y(k,v1)-states_y(k-1,v0_domain)).^2) ...
              + beta(k)*( (states_x(k+1,v2)-2*states_x(k,v1) ...
                       + states_x(k-1,v0_domain)).^2 ...
                     + (states_y(k+1,v2)-2*states_y(k,v1) ...
                       + states_y(k-1,v0_domain)).^2) );
      Smat(k,(v2-1)*num_states+v1) = ...
        y-target(states_i(k,v1));
      Imat(k,(v2-1)*num_states+v1) = i;
    end; end;
  end;

  for v1 = 1:num_states,
    v0_domain = 1:num_states;
    [y,i] = min( Smat(n-1,(v1-1)*num_states+v0_domain) ...
            + alpha(k)*( (states_x(n,v1)-states_x(n-1,v0_domain)).^2 ...
                    + (states_y(n,v1)-states_y(n-1,v0_domain)).^2));
    Smat(n,v1) = y-target(states_i(n,v1));
    Imat(n,v1) = i;
  end;

  [global_e,final_i] = min(Smat(n,1:num_states));


  % backward pass

  snake_pnts = zeros(n,2);

  snake_pnts(n,:) = [states_x(n,final_i),states_y(n,final_i)];
  v1 = final_i; v2 = 1;
  for k=n-1:-1:1,
    v = Imat(k+1,(v2-1)*num_states+v1);
    v2 = v1; v1 = v;
    snake_pnts(k,:) = [states_x(k,v1),states_y(k,v1)];
  end;

  fprintf('\n');
