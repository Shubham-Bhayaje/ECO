import 'package:flutter/material.dart';

class LocationSearchField extends StatefulWidget {
  final String hintText;
  final Function(String) onSearch;
  final Function() onClear;
  final List<String> suggestions;

  const LocationSearchField({
    Key? key,
    required this.hintText,
    required this.onSearch,
    required this.onClear,
    this.suggestions = const [],
  }) : super(key: key);

  @override
  State<LocationSearchField> createState() => _LocationSearchFieldState();
}

class _LocationSearchFieldState extends State<LocationSearchField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _showSuggestions = _focusNode.hasFocus && widget.suggestions.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F172A).withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            onChanged: (val) {
              widget.onSearch(val);
              setState(() {
                _showSuggestions = _focusNode.hasFocus && widget.suggestions.isNotEmpty;
              });
            },
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0xFF0F172A),
            ),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: const TextStyle(
                color: Color(0xFF94A3B8),
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF059669)),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear_rounded, color: Color(0xFF64748B), size: 20),
                onPressed: () {
                  _controller.clear();
                  widget.onClear();
                  setState(() {
                    _showSuggestions = false;
                  });
                },
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
        if (_showSuggestions) ...[
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0F172A).withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: widget.suggestions.length,
              separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFF1F5F9)),
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.location_on_rounded, size: 20, color: Color(0xFF94A3B8)),
                  title: Text(
                    widget.suggestions[index],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  onTap: () {
                    _controller.text = widget.suggestions[index];
                    _focusNode.unfocus();
                    setState(() {
                      _showSuggestions = false;
                    });
                  },
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}
