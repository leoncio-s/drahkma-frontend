Uri joinUrl(Uri base, String segment)
{
  return base.replace(
    pathSegments: [...base.pathSegments, segment]
  );
}