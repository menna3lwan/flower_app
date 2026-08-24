/// Sub-status enum for a feature's `Loaded` state variant (e.g. background refresh in flight) — doesn't replace sealed states.
enum ViewStatus { idle, submitting, refreshing }
