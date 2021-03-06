function [ds p0] = computeDistanceOfMirror(qs, ns, A)

num_of_mirror = size(ns,2);

K = [];

z3 = zeros(3,1);

if num_of_mirror == 2

  x0 = transformVectorToSkewSymmetricMatrix(inv(A)*transformToHomogeneousCoordinateSystem(qs{1})');
  x1 = transformVectorToSkewSymmetricMatrix(inv(A)*transformToHomogeneousCoordinateSystem(qs{2})');
  x2 = transformVectorToSkewSymmetricMatrix(inv(A)*transformToHomogeneousCoordinateSystem(qs{3})');
  x12 = transformVectorToSkewSymmetricMatrix(inv(A)*transformToHomogeneousCoordinateSystem(qs{4})');    
  x21 = transformVectorToSkewSymmetricMatrix(inv(A)*transformToHomogeneousCoordinateSystem(qs{5})');

  H1 = computeHouseholderTransformationMain(ns{1});
  H2 = computeHouseholderTransformationMain(ns{2});

  h1 = x1 * H1;
  h2 = x2 * H2;

  h12 = x12 * H1 * H2;
  h21 = x21 * H2 * H1;

  hn12 = x12 * H1 * ns{2};
  hn21 = x21 * H2 * ns{1};

  K = [...
	x0,            z3,           z3; ...
        h1,   -2*x1*ns{1},           z3; ...
	h2,            z3,  -2*x2*ns{2}; ...
	h12, -2*x12*ns{1},      -2*hn12; ...
	h21,      -2*hn21,  -2*x21*ns{2}];

elseif num_of_mirror == 3

  x0 = transformVectorToSkewSymmetricMatrix(inv(A)*transformToHomogeneousCoordinateSystem(qs{1})');
  x1 = transformVectorToSkewSymmetricMatrix(inv(A)*transformToHomogeneousCoordinateSystem(qs{2})');
  x2 = transformVectorToSkewSymmetricMatrix(inv(A)*transformToHomogeneousCoordinateSystem(qs{3})');
  x3 = transformVectorToSkewSymmetricMatrix(inv(A)*transformToHomogeneousCoordinateSystem(qs{4})');    
  x12 = transformVectorToSkewSymmetricMatrix(inv(A)*transformToHomogeneousCoordinateSystem(qs{5})');
  x13 = transformVectorToSkewSymmetricMatrix(inv(A)*transformToHomogeneousCoordinateSystem(qs{6})');
  x21 = transformVectorToSkewSymmetricMatrix(inv(A)*transformToHomogeneousCoordinateSystem(qs{7})');
  x23 = transformVectorToSkewSymmetricMatrix(inv(A)*transformToHomogeneousCoordinateSystem(qs{8})');
  x31 = transformVectorToSkewSymmetricMatrix(inv(A)*transformToHomogeneousCoordinateSystem(qs{9})');
  x32 = transformVectorToSkewSymmetricMatrix(inv(A)*transformToHomogeneousCoordinateSystem(qs{10})');
    
  H1 = computeHouseholderTransformationMain(ns{1});
  H2 = computeHouseholderTransformationMain(ns{2});
  H3 = computeHouseholderTransformationMain(ns{3});

  h1 = x1 * H1;
  h2 = x2 * H2;
  h3 = x3 * H3;

  h12 = x12 * H1 * H2;
  h13 = x13 * H1 * H3;
  h21 = x21 * H2 * H1;
  h23 = x23 * H2 * H3;
  h31 = x31 * H3 * H1;
  h32 = x32 * H3 * H2;

  hn12 = x12 * H1 * ns{2};
  hn13 = x13 * H1 * ns{3};
  hn21 = x21 * H2 * ns{1};
  hn23 = x23 * H2 * ns{3};
  hn31 = x31 * H3 * ns{1};
  hn32 = x32 * H3 * ns{2};

  K = [...
    x0,            z3,          z3,            z3; ...
    h1,   -2*x1*ns{1},          z3,            z3; ...
    h2,            z3, -2*x2*ns{2},            z3; ...
    h3,            z3,          z3,   -2*x3*ns{3}; ...
    h12, -2*x12*ns{1},     -2*hn12,            z3; ...
    h21,      -2*hn21, -2*x21*ns{2},           z3; ...
    h23,           z3, -2*x23*ns{2},      -2*hn23; ...
    h32,           z3,      -2*hn32, -2*x32*ns{3}; ...
    h31,      -2*hn31,           z3, -2*x31*ns{3}; ...
    h13, -2*x13*ns{1},           z3,      -2*hn13;
];

end

T = K'*K;
[V D] = eig(T);
x = V(:,1);

if num_of_mirror == 2

  p0 = x(1:3);
  ds{1} = x(4) / x(4);
  ds{2} = x(5) / x(4);

elseif num_of_mirror == 3

  p0 = x(1:3);
  ds{1} = x(4) / x(4);
  ds{2} = x(5) / x(4);
  ds{3} = x(6) / x(4);

end