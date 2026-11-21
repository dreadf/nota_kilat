/// Alamat dan kunci publik project Supabase NotaKilat.
///
/// Aman masuk repo: publishable (anon) key memang kunci publik, keamanan data
/// dijaga oleh RLS di database. JANGAN PERNAH menaruh `service_role` atau
/// secret key di sini atau di mana pun di repo.
abstract final class SupabaseConfig {
  static const String url = 'https://xmaqunccrqtxafuapadz.supabase.co';
  static const String publishableKey =
      'sb_publishable_eNt2xjtc2Gia1kND1NuTAA_j-aqLHiA';
}
