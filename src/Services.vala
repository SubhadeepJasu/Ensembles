using Vinject;
using Ensembles.ArrangerWorkstation;

/*
 * What's happening here is that `Services` is a namespace shared among
 * all the modules. It's where all the dependency injection stuff lives.
 */
namespace Ensembles.Services {
    static Injector di_container;
}
