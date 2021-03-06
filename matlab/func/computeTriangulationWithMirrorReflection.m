function ps = computeTriangulationWithMirrorReflection(qs, ns, ds, A, num_of_mirror)

for i_m = 1:num_of_mirror+1
  qs_h{i_m} = transformToHomogeneousCoordinateSystem(qs{i_m});
end  

for i_m = 1:num_of_mirror
  Hs{i_m} = computeHouseholderTransformation(ns{i_m}, ds{i_m});
end  

ps = [];

for i_point = 1:size(qs{1}, 1)
  for i_m = 1:num_of_mirror+1
    q_h{i_m} = qs_h{i_m}(i_point,:)';
  end

  K = [];
  L = [];
  
  for i_m = 1:num_of_mirror
    K_tmp = [inv(A)*q_h{1}, zeros(3,num_of_mirror)];
    K_tmp(:,i_m+1) = - Hs{i_m}(1:3,1:3)*inv(A)*q_h{i_m+1};
    K = [K; K_tmp];
    
    L_tmp = Hs{i_m}(1:3,4);
    L = [L; L_tmp];
  end

  K2 = K'*K;
  L2 = K'*L;
  
  X = inv(K2) * L2;

  p{1} = X(1,1) * inv(A) * q_h{1};
  p_candidate = [p{1}'];
  
  for i_m = 1:num_of_mirror
    p{i_m+1} = X(i_m+1,1)*Hs{i_m}(1:3,1:3)*inv(A)*q_h{i_m+1} + Hs{i_m}(1:3,4);
    p_candidate = [p_candidate; p{i_m+1}'];
  end

  p_ave = mean(p_candidate);
  ps = [ps; p_ave];
end
