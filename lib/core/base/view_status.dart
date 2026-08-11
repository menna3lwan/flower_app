/// Shared status enum used *inside* a feature's sealed state as a field
/// (e.g. `HomeLoaded(status: ViewStatus.refreshing, ...)`), for the common
/// case of "loaded, but a background refresh/submit is in flight".
///
/// This does not replace sealed states — each feature still models its
/// own `Initial/Loading/Loaded/Error` variants as a sealed class. This
/// enum only helps express sub-states of a single `Loaded` variant
/// without exploding the number of state classes.
enum ViewStatus { idle, submitting, refreshing }
