import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';
import 'package:collection/collection.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'dart:math' as math; // Needed for random icons

void main() {
  runApp(const MyApp());
}

// --- Data Structure for Node Details ---
class PersonNodeData {
  final String name;
  final IconData icon;
  // Add more fields later: notes, birthday, relationshipType etc.

  PersonNodeData({required this.name, required this.icon});
}

// --- Define Static Color Schemes (Fallback) ---
// Updated with M3 recommendations
const _defaultLightColorScheme = ColorScheme.light(
  brightness: Brightness.light,
  primary: Color(0xFF6750A4),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFEADDFF),
  onPrimaryContainer: Color(0xFF21005D),
  secondary: Color(0xFF625B71),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFE8DEF8),
  onSecondaryContainer: Color(0xFF1D192B),
  tertiary: Color(0xFF7D5260),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFFFD8E4),
  onTertiaryContainer: Color(0xFF31111D),
  error: Color(0xFFB3261E),
  onError: Color(0xFFFFFFFF),
  errorContainer: Color(0xFFF9DEDC),
  onErrorContainer: Color(0xFF410E0B),
  surface: Color(0xFFFFFBFE),
  onSurface: Color(0xFF1C1B1F),
  onSurfaceVariant: Color(0xFF49454F),
  outline: Color(0xFF79747E), // Removed deprecated surfaceVariant
  outlineVariant: Color(0xFFCAC4D0),
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),
  inverseSurface: Color(0xFF313033),
  onInverseSurface: Color(0xFFF4EFF4),
  inversePrimary: Color(0xFFD0BCFF),
  surfaceTint: Color(0xFF6750A4),
  surfaceContainerLowest: Color(0xFFFFFFFF),
  surfaceContainerLow: Color(0xFFF7F2FA),
  surfaceContainer: Color(0xFFF3EDF7),
  surfaceContainerHigh: Color(0xFFEDE7F4),
  surfaceContainerHighest: Color(0xFFE6E0EC),
);

const _defaultDarkColorScheme = ColorScheme.dark(
  brightness: Brightness.dark,
  primary: Color(0xFFD0BCFF),
  onPrimary: Color(0xFF381E72),
  primaryContainer: Color(0xFF4F378B),
  onPrimaryContainer: Color(0xFFEADDFF),
  secondary: Color(0xFFCCC2DC),
  onSecondary: Color(0xFF332D41),
  secondaryContainer: Color(0xFF4A4458),
  onSecondaryContainer: Color(0xFFE8DEF8),
  tertiary: Color(0xFFEFB8C8),
  onTertiary: Color(0xFF492532),
  tertiaryContainer: Color(0xFF633B48),
  onTertiaryContainer: Color(0xFFFFD8E4),
  error: Color(0xFFF2B8B5),
  onError: Color(0xFF601410),
  errorContainer: Color(0xFF8C1D18),
  onErrorContainer: Color(0xFFF9DEDC),
  surface: Color(0xFF16141A),
  onSurface: Color(0xFFE6E1E5),
  onSurfaceVariant: Color(0xFFCAC4D0),
  outline: Color(0xFF938F99), // Removed deprecated surfaceVariant
  outlineVariant: Color(0xFF49454F), // Grid lines, softer edges
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),
  inverseSurface: Color(0xFFE6E1E5),
  onInverseSurface: Color(0xFF313033),
  inversePrimary: Color(0xFF6750A4),
  surfaceTint: Color(0xFFD0BCFF),
  // Surface container roles (approximate values if not provided by dynamic color)
  surfaceContainerLowest: Color(0xFF0F0D13),
  surfaceContainerLow: Color(0xFF1C1B1F),
  surfaceContainer: Color(0xFF201F23),
  surfaceContainerHigh: Color(0xFF2B292E),
  surfaceContainerHighest: Color(0xFF36343A),
);

// --- Root Application Widget ---
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme lightColorScheme = lightDynamic ?? _defaultLightColorScheme;
        ColorScheme darkColorScheme = darkDynamic ?? _defaultDarkColorScheme;

        // Ensure surface container roles are present via copyWith, remove redundant null checks
        lightColorScheme = lightColorScheme.copyWith(
          surfaceContainerLowest: lightColorScheme.surfaceContainerLowest,
          surfaceContainerLow: lightColorScheme.surfaceContainerLow,
          surfaceContainer: lightColorScheme.surfaceContainer,
          surfaceContainerHigh: lightColorScheme.surfaceContainerHigh,
          surfaceContainerHighest: lightColorScheme.surfaceContainerHighest,
        );
        darkColorScheme = darkColorScheme.copyWith(
          surfaceContainerLowest: darkColorScheme.surfaceContainerLowest,
          surfaceContainerLow: darkColorScheme.surfaceContainerLow,
          surfaceContainer: darkColorScheme.surfaceContainer,
          surfaceContainerHigh: darkColorScheme.surfaceContainerHigh,
          surfaceContainerHighest: darkColorScheme.surfaceContainerHighest,
        );

        return MaterialApp(
          title: 'Relationship Graph',
          theme: _buildThemeData(lightColorScheme),
          darkTheme: _buildThemeData(darkColorScheme),
          home: const RelationshipGraphPage(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }

  ThemeData _buildThemeData(ColorScheme colorScheme) {
    // Remove redundant null checks - assume ColorScheme has these properties
    final Color surfaceContainerLow = colorScheme.surfaceContainerLow;
    final Color surfaceContainerLowest = colorScheme.surfaceContainerLowest;

    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      fontFamily: 'Roboto',
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w500,
          fontSize: 20,
          color: colorScheme.onSurface,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 0,
        color: ElevationOverlay.applySurfaceTint(
          colorScheme.surface,
          colorScheme.surfaceTint,
          1.0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: colorScheme.outlineVariant.withAlpha((0.5 * 255).round()),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withAlpha(
          (0.4 * 255).round(),
        ),
        hintStyle: TextStyle(
          color: colorScheme.onSurfaceVariant.withAlpha((0.7 * 255).round()),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: colorScheme.outline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: colorScheme.inverseSurface,
        contentTextStyle: TextStyle(color: colorScheme.onInverseSurface),
      ),
      tooltipTheme: TooltipThemeData(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: colorScheme.inverseSurface,
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: TextStyle(color: colorScheme.onInverseSurface, fontSize: 12),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      // Pass surface container colors down if needed by custom components
      extensions: <ThemeExtension<dynamic>>[
        SurfaceContainerColors(
          lowest: surfaceContainerLowest,
          low: surfaceContainerLow,
        ),
      ],
    );
  }
}

// --- Theme Extension for Surface Container Colors ---
// Helper to pass surface container colors if not directly in ColorScheme
@immutable
class SurfaceContainerColors extends ThemeExtension<SurfaceContainerColors> {
  const SurfaceContainerColors({required this.lowest, required this.low});
  final Color lowest;
  final Color low;

  @override
  SurfaceContainerColors copyWith({Color? lowest, Color? low}) {
    return SurfaceContainerColors(
      lowest: lowest ?? this.lowest,
      low: low ?? this.low,
    );
  }

  @override
  SurfaceContainerColors lerp(
    ThemeExtension<SurfaceContainerColors>? other,
    double t,
  ) {
    if (other is! SurfaceContainerColors) {
      return this;
    }
    return SurfaceContainerColors(
      lowest: Color.lerp(lowest, other.lowest, t)!,
      low: Color.lerp(low, other.low, t)!,
    );
  }
}

// --- Main Page Widget ---
class RelationshipGraphPage extends StatefulWidget {
  const RelationshipGraphPage({super.key});
  @override
  RelationshipGraphPageState createState() => RelationshipGraphPageState(); // Updated: Made State class public
}

// --- State for the Main Page ---
class RelationshipGraphPageState extends State<RelationshipGraphPage>
    with TickerProviderStateMixin {
  // Updated: Made State class public
  final Graph graph = Graph();
  late FruchtermanReingoldAlgorithm _algorithm;
  final TextEditingController _nodeNameController = TextEditingController();
  List<Node> selectedNodes = [];
  final TransformationController _transformationController =
      TransformationController();
  late AnimationController _graphUpdateAnimationController;
  late Animation<double> _graphFadeAnimation;

  bool _isSearching = false;
  String _searchText = '';
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  static const youNodeKey = ValueKey("You");
  final Map<ValueKey, PersonNodeData> _nodeDataMap = {
    youNodeKey: PersonNodeData(name: "You", icon: Icons.account_circle_rounded),
  };

  @override
  void initState() {
    super.initState();
    _algorithm = FruchtermanReingoldAlgorithm(
      iterations: 350,
      attractionPercentage: 0.8,
      repulsionPercentage: 0.6,
    );
    _graphUpdateAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _graphFadeAnimation = CurvedAnimation(
      parent: _graphUpdateAnimationController,
      curve: Curves.easeInOut,
    );

    final youNode = Node.Id(DateTime.now().millisecondsSinceEpoch.toString());
    youNode.key = youNodeKey;
    graph.addNode(youNode);

    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text;
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
        _graphUpdateAnimationController.forward(from: 1.0);
      }
    });
  }

  @override
  void dispose() {
    _nodeNameController.dispose();
    _transformationController.dispose();
    _graphUpdateAnimationController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  // --- Core Logic Methods ---
  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  IconData _getRandomIcon() {
    const icons = [
      Icons.person_outline_rounded,
      Icons.work_outline_rounded,
      Icons.home_outlined,
      Icons.star_border_rounded,
      Icons.favorite_border_rounded,
      Icons.lightbulb_outline_rounded,
      Icons.settings_outlined,
      Icons.group_outlined,
      Icons.place_outlined,
      Icons.folder_outlined,
      Icons.bookmark_border_rounded,
      Icons.pets_rounded,
      Icons.bubble_chart_outlined,
      Icons.anchor_rounded,
      Icons.build_circle_outlined,
      Icons.camera_alt_outlined,
    ];
    final random = math.Random();
    return icons[random.nextInt(icons.length)];
  }

  void _triggerGraphUpdateAnimation() {
    if (!mounted) return;
    _graphUpdateAnimationController.forward(from: 0.0);
    setState(
      () {},
    ); // MUST call setState here to rebuild with updated graph data
  }

  void _handleNodeTap(Node node) {
    if (_isSearching) _stopSearch();
    setState(() {
      // Direct setState for selection changes
      if (selectedNodes.contains(node)) {
        selectedNodes.remove(node);
      } else {
        if (selectedNodes.length < 2) {
          selectedNodes.add(node);
        } else {
          _showSnackBar("Select a maximum of 2 nodes.");
        }
      }
    });
  }

  void _clearSelection() {
    setState(() {
      selectedNodes.clear();
    }); // Direct setState
  }

  void _addNode({String? initialName}) {
    final nameController = TextEditingController(text: initialName ?? '');
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Add New Person"),
            content: TextField(
              controller: nameController,
              autofocus: true,
              decoration: const InputDecoration(hintText: "Name"),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              FilledButton(
                onPressed: () {
                  final String name = nameController.text.trim();
                  Navigator.pop(context);
                  if (name.isEmpty) {
                    _showSnackBar("Name cannot be empty.");
                    return;
                  }
                  final nodeKey = ValueKey(name);
                  if (_nodeDataMap.containsKey(nodeKey)) {
                    _showSnackBar("Node named '$name' already exists.");
                    return;
                  }

                  final newNode = Node.Id(
                    DateTime.now().millisecondsSinceEpoch.toString(),
                  );
                  newNode.key = nodeKey;
                  _nodeDataMap[nodeKey] = PersonNodeData(
                    name: name,
                    icon: _getRandomIcon(),
                  );
                  graph.addNode(newNode);

                  if (selectedNodes.length == 1) {
                    graph.addEdge(selectedNodes[0], newNode);
                  } else {
                    final youNode = graph.getNodeUsingValueKey(youNodeKey);
                    if (youNode != null) {
                      graph.addEdge(youNode, newNode);
                    }
                  }
                  _triggerGraphUpdateAnimation(); // Trigger rebuild and animation
                },
                child: const Text("Add"),
              ),
            ],
          ),
    );
  }

  void _removeSelectedNodes() {
    if (selectedNodes.isEmpty) return;
    bool didRemove = false;
    for (var nodeToRemove in List.from(selectedNodes)) {
      if (nodeToRemove.key == youNodeKey) {
        _showSnackBar("Cannot remove the 'You' node.");
        continue;
      }
      if (nodeToRemove.key != null && nodeToRemove.key is ValueKey) {
        _nodeDataMap.remove(nodeToRemove.key as ValueKey);
      }
      graph.removeNode(nodeToRemove);
      didRemove = true;
    }
    if (didRemove) {
      selectedNodes.clear();
      _triggerGraphUpdateAnimation(); // Trigger rebuild and animation
    }
  }

  void _connectSelectedNodes() {
    if (selectedNodes.length != 2) {
      _showSnackBar("Select exactly two nodes to connect.");
      return;
    }
    final node1 = selectedNodes[0];
    final node2 = selectedNodes[1];
    if (graph.getEdgeBetween(node1, node2) != null) {
      _showSnackBar("Nodes are already connected.");
    } else {
      graph.addEdge(node1, node2);
      _clearSelection();
      _triggerGraphUpdateAnimation();
    } // Trigger
  }

  void _disconnectSelectedNodes() {
    if (selectedNodes.length != 2) {
      _showSnackBar("Select exactly two nodes to disconnect.");
      return;
    }
    final node1 = selectedNodes[0];
    final node2 = selectedNodes[1];
    final edge = graph.getEdgeBetween(node1, node2);
    if (edge != null) {
      graph.removeEdge(edge);
      _clearSelection();
      _triggerGraphUpdateAnimation();
    } // Trigger
    else {
      _showSnackBar("Nodes are not connected.");
    }
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
    _searchFocusNode.requestFocus();
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchText = '';
      _searchController.clear();
    });
    _searchFocusNode.unfocus();
  }

  // --- Build Method ---
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final showConnectionActions = selectedNodes.length == 2;
    final showRemoveAction =
        selectedNodes.isNotEmpty &&
        selectedNodes.any(
          (n) => n.key != youNodeKey,
        ); // Allow removing multiple if needed
    final showClearAction = selectedNodes.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title:
            _isSearching
                ? TextField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  autofocus: true,
                  style: TextStyle(color: colorScheme.onSurface),
                  decoration: InputDecoration(
                    hintText: "Search nodes...",
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                  ),
                )
                : const Text("Relationship Graph"),
        actions:
            _isSearching
                ? [
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: _stopSearch,
                    tooltip: "Close Search",
                  ),
                ]
                : [
                  if (showConnectionActions)
                    IconButton(
                      icon: const Icon(Icons.link_off_rounded),
                      onPressed: _disconnectSelectedNodes,
                      tooltip: "Disconnect Selected",
                    ),
                  if (showConnectionActions)
                    IconButton(
                      icon: const Icon(Icons.link_rounded),
                      onPressed: _connectSelectedNodes,
                      tooltip: "Connect Selected",
                    ),
                  if (showRemoveAction)
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded),
                      onPressed: _removeSelectedNodes,
                      tooltip: "Remove Selected",
                    ), // Updated label potentially
                  if (showClearAction)
                    IconButton(
                      icon: const Icon(Icons.clear_all_rounded),
                      onPressed: _clearSelection,
                      tooltip: "Clear Selection",
                    ),
                  IconButton(
                    icon: const Icon(Icons.search_rounded),
                    onPressed: _startSearch,
                    tooltip: "Search Nodes",
                  ),
                ],
      ),
      body: _buildGraphView(colorScheme),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNode(),
        tooltip: 'Add Person',
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  // --- UI Helper Methods ---

  Widget _buildGraphView(ColorScheme colorScheme) {
    // Get surface container colors safely using the theme extension or fallback
    final surfaceColors =
        Theme.of(context).extension<SurfaceContainerColors>() ??
        SurfaceContainerColors(
          lowest: colorScheme.surface,
          low: colorScheme.surface,
        );
    final Color graphBackgroundColor =
        colorScheme.brightness == Brightness.dark
            ? surfaceColors.lowest
            : surfaceColors.low;

    return Container(
      decoration: BoxDecoration(color: graphBackgroundColor),
      clipBehavior: Clip.none,
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: GridPainter(
                colorScheme.outlineVariant.withAlpha((0.2 * 255).round()),
                spacing: 40,
              ),
            ),
          ),
          InteractiveViewer(
            transformationController: _transformationController,
            constrained: false,
            boundaryMargin: const EdgeInsets.all(200),
            minScale: 0.05,
            maxScale: 5.0,
            interactionEndFrictionCoefficient: 0.001,
            child: FadeTransition(
              opacity: _graphFadeAnimation,
              child: GraphView(
                graph: graph,
                algorithm: _algorithm,
                paint:
                    Paint()
                      ..color = colorScheme.outlineVariant.withAlpha(
                        (0.5 * 255).round(),
                      )
                      ..strokeWidth = 1.5
                      ..style = PaintingStyle.stroke
                      ..strokeCap = StrokeCap.round,
                builder: (Node node) => _buildNodeWidget(node, colorScheme),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNodeWidget(Node node, ColorScheme colorScheme) {
    final bool isYou = node.key == youNodeKey;
    final bool isSelected = selectedNodes.contains(node);
    final ValueKey? key = node.key is ValueKey ? node.key as ValueKey : null;
    final PersonNodeData? nodeData = key != null ? _nodeDataMap[key] : null;
    final String label = nodeData?.name ?? "Node";
    final IconData iconData = nodeData?.icon ?? Icons.blur_circular;

    final bool isDimmed =
        _isSearching &&
        _searchText.isNotEmpty &&
        !label.toLowerCase().contains(_searchText.toLowerCase());

    Color bgColor =
        isYou ? colorScheme.tertiaryContainer : colorScheme.secondaryContainer;
    Color contentColor =
        isYou
            ? colorScheme.onTertiaryContainer
            : colorScheme.onSecondaryContainer;
    double scale = isSelected ? 1.15 : 1.0;
    Border? border =
        isSelected
            ? Border.all(
              color: colorScheme.primary.withAlpha((0.8 * 255).round()),
              width: 2.5,
            )
            : null;
    List<BoxShadow>? boxShadow = [
      BoxShadow(
        color:
            isSelected
                ? colorScheme.primary.withAlpha((0.3 * 255).round())
                : colorScheme.shadow.withAlpha((0.2 * 255).round()),
        blurRadius: isSelected ? 10.0 : 5.0,
        spreadRadius: isSelected ? 1.5 : 0.5,
        offset: Offset(0, isSelected ? 4 : 2),
      ),
    ];

    if (isSelected) {
      bgColor = colorScheme.primaryContainer;
      contentColor = colorScheme.onPrimaryContainer;
    }

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: isDimmed ? 0.3 : 1.0,
      child: GestureDetector(
        onTap: () => _handleNodeTap(node),
        child: Tooltip(
          message: label,
          preferBelow: false,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn,
            padding: const EdgeInsets.all(10.0),
            transformAlignment: Alignment.center,
            transform: Matrix4.identity()..scale(scale),
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
              border: border,
              boxShadow: boxShadow,
            ),
            child: Icon(iconData, size: 18, color: contentColor),
          ),
        ),
      ),
    );
  }
}

// --- Custom Painter & Extensions ---
class GridPainter extends CustomPainter {
  final Color color;
  final double spacing;
  GridPainter(this.color, {this.spacing = 40.0});
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = 0.5;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

extension GraphExtensions on Graph {
  Node? getNodeUsingValueKey(ValueKey key) {
    return nodes.firstWhereOrNull((n) => n.key == key);
  }

  Edge? getEdgeBetween(Node node1, Node node2) {
    return edges.firstWhereOrNull(
      (edge) =>
          (edge.source == node1 && edge.destination == node2) ||
          (edge.source == node2 && edge.destination == node1),
    );
  }
}
