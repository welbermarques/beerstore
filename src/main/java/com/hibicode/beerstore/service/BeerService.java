package com.hibicode.beerstore.service;

import com.hibicode.beerstore.model.Beer;
import com.hibicode.beerstore.repository.Beers;
import com.hibicode.beerstore.service.exception.BeerAlreadyExistException;
import com.hibicode.beerstore.service.exception.EntityNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class BeerService {

    private Beers beers;

    public BeerService(@Autowired Beers beers) {
        this.beers = beers;
    }

    public Beer save(final Beer beer) {
        verifyIfBeerExists(beer);

        return beers.save(beer);
    }

    public void remove(final Long id) {
        Beer beerDatabase = beerExist(id);
        beers.delete(beerDatabase);
    }

    public Beer byId(Long id) {
        Beer beerDatabase = beerExist(id);
        return beerDatabase;
    }

    private Beer beerExist(Long id) {
        Optional<Beer> beerPresent = beers.findById(id);
        if(!beerPresent.isPresent()) {
            throw new EntityNotFoundException();
        }

        return beerPresent.get();
    }

    private void verifyIfBeerExists(final Beer beer) {
        Optional<Beer> beerByNameAndType = beers.findByNameAndType
                (beer.getName(), beer.getType());

        if (beerByNameAndType.isPresent() && (beer.isNew() ||
                isUpdatingToADifferentBeer(beer, beerByNameAndType))) {
            throw new BeerAlreadyExistException();
        }
    }

    private boolean isUpdatingToADifferentBeer(Beer beer,
                                               Optional<Beer> beerByNameAndType) {
        return beer.alreadyExist() && !beerByNameAndType.get()
                .equals(beer);
    }

}
